"""Independent event-clock BRAM banks; sys reads only a completed frozen capture."""
from migen import *
from migen.genlib.cdc import MultiReg

class TdcBuffers(Module):
    def __init__(self, depth=4096, domains=None):
        domains = domains or ['tdc1'] * 4 + ['tdc2'] * 4 + ['tdc3'] * 4
        if depth < 2 or depth & (depth - 1) or not domains:
            raise ValueError('power-of-two depth >=2 and nonempty domains required')
        self.arm = Signal()
        self.stop = Signal()
        self.ready = Signal()
        self.started = Signal()
        self.busy = Signal()
        self.valid = Signal()
        self.done = Signal()
        self.rejected = Signal()
        self.capture_id = Signal(32)
        self.address = Signal(max=depth)
        self.events = [Signal(name='event%d' % i) for i in range(len(domains))]
        self.raw = [Signal(13, name='raw%d' % i) for i in range(len(domains))]
        self.data = []
        self.counts = [Signal(max=depth + 1) for _ in domains]
        epoch = Signal()
        stop_epoch = Signal()
        completed = []
        started = []
        snapshots = []
        for ch, domain in enumerate(domains):
            request = Signal()
            stop_request = Signal()
            seen = Signal()
            stop_seen = Signal()
            acknowledged = Signal()
            active = Signal()
            count = Signal(max=depth + 1)
            ack_sys = Signal()
            seen_sys = Signal()
            snapshot = Signal.like(count)
            self.specials += [MultiReg(epoch, request, domain, n=3),
                              MultiReg(stop_epoch, stop_request, domain, n=3),
                              MultiReg(acknowledged, ack_sys, n=3),
                              MultiReg(seen, seen_sys, n=3),
                              MultiReg(count, snapshot, n=2)]
            completed.append(ack_sys == epoch)
            started.append(seen_sys == epoch)
            snapshots.append(snapshot)
            mem = Memory(16, depth, name='tdc_events%d' % ch)
            wp = mem.get_port(write_capable=True, clock_domain=domain)
            rp = mem.get_port(clock_domain='sys', mode=READ_FIRST)
            self.specials += mem, wp, rp
            self.data.append(rp.dat_r)
            write = active & (count < depth) & self.events[ch] & (request == seen) & (stop_request == stop_seen)
            self.comb += [wp.adr.eq(count), wp.dat_w.eq(self.raw[ch]), wp.we.eq(write),
                          rp.adr.eq(self.address)]
            source_sync = getattr(self.sync, domain)
            source_sync += [
                If(request != seen,
                   seen.eq(request), stop_seen.eq(stop_request), count.eq(0), active.eq(1))
                .Elif(stop_request != stop_seen,
                      stop_seen.eq(stop_request),
                      If(active, active.eq(0), acknowledged.eq(seen)))
                .Elif(active,
                      If(count == depth, active.eq(0), acknowledged.eq(seen))
                      .Elif(self.events[ch], count.eq(count + 1)))
            ]
        all_completed = completed[0]
        all_started = started[0]
        for value in completed[1:]:
            all_completed = all_completed & value
        for value in started[1:]:
            all_started = all_started & value
        self.comb += [self.ready.eq(~self.busy & all_completed),
                      self.started.eq(self.busy & all_started)]
        self.sync += [self.done.eq(0), self.rejected.eq(0),
            If(self.arm,
               If(self.ready & ~self.stop,
                  epoch.eq(~epoch), self.busy.eq(1), self.valid.eq(0),
                  *[c.eq(0) for c in self.counts])
               .Else(self.rejected.eq(1))),
            If(self.stop,
               If(self.started & ~self.arm, stop_epoch.eq(~stop_epoch))
               .Else(self.rejected.eq(1))),
            If(self.busy & all_completed,
               self.busy.eq(0), self.valid.eq(1), self.done.eq(1),
               self.capture_id.eq(self.capture_id + 1),
               *[c.eq(v) for c, v in zip(self.counts, snapshots)])]
