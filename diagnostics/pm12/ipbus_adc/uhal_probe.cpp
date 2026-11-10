#include <uhal/uhal.hpp>
#include <iostream>
#include <stdexcept>
int main(int argc,char**argv){
 if(argc!=3)return 2;
 try{
  uhal::setLogLevelTo(uhal::Error());
  auto hw=uhal::ConnectionManager::getDevice("pm12",argv[1],argv[2]);
  auto id=hw.getNode("DEVICE_ID").read();auto build=hw.getNode("BUILD_ID").read();hw.dispatch();
  if(id.value()!=0x504d1202)throw std::runtime_error("wrong identity");
  auto old=hw.getNode("SCRATCH").read();hw.dispatch();
  for(unsigned i=0;i<100;i++){
   uint32_t x=0xa55a0000^i;hw.getNode("SCRATCH").write(x);auto r=hw.getNode("SCRATCH").read();hw.dispatch();if(r.value()!=x)throw std::runtime_error("scratch mismatch");
  }
  hw.getNode("SCRATCH").write(old.value());hw.dispatch();
  // Caller prepares a frozen bank0 synthetic capture before invoking this probe.
  unsigned checks=0;
  for(unsigned ch=0;ch<12;ch++){
   auto words=hw.getNode("adc.ch"+std::to_string(ch+1)).readBlock(4096);hw.dispatch();
   for(unsigned i=0;i<4096;i++){if(words[i]!=(i^(ch*0x1111)))throw std::runtime_error("ADC block mismatch");checks++;}
  }
  std::cout<<"{\"official_uhal\":\"PASS\",\"build_id\":"<<build.value()<<",\"verified_samples\":"<<checks<<",\"scratch_roundtrips\":100}"<<std::endl;
 }catch(const std::exception&e){std::cerr<<e.what()<<std::endl;return 1;}
}
