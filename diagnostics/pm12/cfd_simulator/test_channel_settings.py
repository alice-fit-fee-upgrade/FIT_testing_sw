import unittest
from channel_settings import adc_address, connected_channels, require_serial_reply, snapshot_sources

class ChannelSettings(unittest.TestCase):
    def test_all_twelve_addresses(self):
        self.assertEqual([adc_address(c) for c in range(1,13)],[0x10000+i*4096 for i in range(12)])
        for bad in [0,13,-1,True,'12']:
            with self.assertRaises(ValueError):adc_address(bad)
    def test_shared_monitor_always_has_complete_inventory(self):
        for connected in [[1,2,3,4],[5,6,7,8],[9,10,11,12],[12,10,8,6]]:
            self.assertEqual(connected_channels(connected),(connected,connected))
            self.assertEqual(connected_channels(connected,connected[:1]),(connected,connected[:1]))
        for connected,selected in [([1,2,3],None),([1,2,3,3],None),([1,2,3,13],None),([1,2,3,4],[12]),([1,2,3,4],[1,1]),([1,2,3,4],[])]:
            with self.assertRaises(ValueError):connected_channels(connected,selected)
    def test_real_uart_format_and_serial_boundaries(self):
        require_serial_reply('Board S/N: 1803 Flash Timestamp: 852AD92B\r\n','1803')
        for reply in ['Board S/N: 18030 Flash Timestamp: abc','Board S/N: 1804','FPGA not ready']:
            with self.assertRaises(ValueError):require_serial_reply(reply,'1803')
    def test_source_snapshot_remains_when_original_changes(self):
        import hashlib,sys,tempfile,types
        from pathlib import Path
        from unittest.mock import patch
        with tempfile.TemporaryDirectory() as directory:
            p=Path(directory);source=p/'driver.py';source.write_text('original source')
            module=types.ModuleType('snapshot_fixture');module.__file__=str(source)
            with patch.dict(sys.modules,{'snapshot_fixture':module}):
                hashes=snapshot_sources(p,['snapshot_fixture'])
            source.write_text('later edit')
            captured=p/'sources/snapshot_fixture.py'
            self.assertEqual(captured.read_text(),'original source')
            self.assertEqual(hashes['sources/snapshot_fixture.py'],hashlib.sha256(captured.read_bytes()).hexdigest())

if __name__=='__main__':unittest.main()
