#include <uhal/uhal.hpp>
#include <fstream>
#include <filesystem>
#include <iostream>
#include <stdexcept>
int main(int argc,char**argv){
 if(argc!=4)return 2;
 try{
  uhal::setLogLevelTo(uhal::Error());
  auto hw=uhal::ConnectionManager::getDevice("pm12",argv[1],argv[2]);
  auto id=hw.getNode("DEVICE_ID").read();auto state=hw.getNode("STATUS").read();auto cap=hw.getNode("CAPTURE_ID").read();hw.dispatch();
  if(id.value()!=0x504d1202 || !(state.value()&1) || (state.value()&18))throw std::runtime_error("need frozen physical capture");
  const std::filesystem::path root(argv[3]);if(std::filesystem::exists(root))throw std::runtime_error("output exists");std::filesystem::create_directories(root);
  unsigned samples=0;
  for(unsigned ch=1;ch<=12;ch++){
   auto words=hw.getNode("adc.ch"+std::to_string(ch)).readBlock(4096);hw.dispatch();
   std::string name="ch"+std::string(ch<10?"0":"")+std::to_string(ch)+".bin";
   std::ofstream f(root/name,std::ios::binary);
   for(auto v:words){if(v>0x3fff || ((v>>12)&1)!=((state.value()>>5)&1))throw std::runtime_error("bad raw sample");f.put(v&255);f.put((v>>8)&255);samples++;}
   if(!f)throw std::runtime_error("output write failed");
  }
  auto end=hw.getNode("CAPTURE_ID").read();auto endState=hw.getNode("STATUS").read();hw.dispatch();
  if(end.value()!=cap.value() || endState.value()!=state.value())throw std::runtime_error("capture changed");
  std::cout<<"{\"official_uhal_physical\":\"PASS\",\"capture_id\":"<<cap.value()<<",\"samples\":"<<samples<<",\"status\":"<<state.value()<<"}"<<std::endl;
 }catch(const std::exception&e){std::cerr<<e.what()<<std::endl;return 1;}
}
