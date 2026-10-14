import copy,json,unittest
from pathlib import Path
from external_verdict import analyze

class PhysicalPacketEvidence(unittest.TestCase):
 def setUp(self):self.e=json.loads(Path(__file__).with_name('validation-2026-10-14.json').read_text())
 def test_physical_bidirectional_window(self):
  result=analyze(self.e['samples'],self.e['udp_host']);self.assertEqual(result['status'],'EXTERNAL_PASS');self.assertEqual([m['mode'] for m in result['modes'] if m['external_packets_pass']],[2048])
 def test_good_rx_with_inverted_tx_is_not_a_packet_pass(self):
  result=analyze(self.e['samples'],self.e['udp_host']);m=next(m for m in result['modes'] if m['mode']==3072);self.assertTrue(m['qualified_rx_link']);self.assertFalse(m['external_packets_pass'])
 def test_host_delivery_is_required(self):
  host=copy.deepcopy(self.e['udp_host']);host['per_second']={};self.assertEqual(analyze(self.e['samples'],host)['status'],'PCS_RX_PASS')
 def test_host_payload_error_fails(self):
  host=copy.deepcopy(self.e['udp_host']);host['bad_payloads']=1;self.assertNotEqual(analyze(self.e['samples'],host)['status'],'EXTERNAL_PASS')
 def test_fpga_reception_is_required(self):
  entries=copy.deepcopy(self.e['samples']);a=next(e for e in entries if e['name']=='MODE_2048_A');next(e for e in entries if e['name']=='MODE_2048_B')['rxframes']=a['rxframes'];self.assertNotEqual(analyze(entries,self.e['udp_host'])['status'],'EXTERNAL_PASS')
 def test_loopback_cannot_be_mislabeled_external(self):
  entries=copy.deepcopy(self.e['samples']);next(e for e in entries if e['name']=='MODE_2048_B')['command']=2;self.assertNotEqual(analyze(entries,self.e['udp_host'])['status'],'EXTERNAL_PASS')
if __name__=='__main__':unittest.main()
