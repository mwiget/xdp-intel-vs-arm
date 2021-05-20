-- xdp_redirect_max_rate.lua

package.path = package.path ..";?.lua;pktgen-21.02.0/?.lua;"

require "Pktgen";
require "Perf";

pktgen.page("range");

pktgen.range.dst_mac(0, "start", "b8:ce:f6:44:d1:e2");
pktgen.range.dst_mac(1, "start", "b8:ce:f6:44:d1:e3");
pktgen.range.dst_mac(2, "start", "04:3f:72:ad:1d:7e");
pktgen.range.dst_mac(3, "start", "04:3f:72:ad:1d:7f");

local stats_file = "stats-redirect.csv";

local send_for_secs = 60;
local max_loss_rate = 0.1;
local start_rate = 1;
-- local start_rate = 0.1;
local pkt_sizes = { 64,128,256,512,1024 };

pktgen.set("all", "size", 64);

pktgen.set_type("all", "ipv4");
pktgen.set_proto("all", "udp");
pktgen.range.src_port("all", "start", 1234);
pktgen.range.dst_port("all", "start", 5678);
pktgen.set("all", "ttl", 64);

pktgen.range.dst_ip(0, "start", "198.18.129.0");
pktgen.range.dst_ip(0, "inc", "0.0.0.1");
pktgen.range.dst_ip(0, "min", "198.18.129.0");
pktgen.range.dst_ip(0, "max", "198.18.255.255");

pktgen.range.dst_ip(1, "start", "198.18.1.0");
pktgen.range.dst_ip(1, "inc", "0.0.0.1");
pktgen.range.dst_ip(1, "min", "198.18.1.0");
pktgen.range.dst_ip(1, "max", "198.18.127.255");

pktgen.range.dst_ip(2, "start", "198.19.129.0");
pktgen.range.dst_ip(2, "inc", "0.0.0.1");
pktgen.range.dst_ip(2, "min", "198.19.129.0");
pktgen.range.dst_ip(2, "max", "198.19.255.255");

pktgen.range.dst_ip(3, "start", "198.19.1.0");
pktgen.range.dst_ip(3, "inc", "0.0.0.1");
pktgen.range.dst_ip(3, "min", "198.19.1.0");
pktgen.range.dst_ip(3, "max", "198.19.127.255");

-- pktgen.range.src_ip("all", "start", "10.10.10.1");
-- pktgen.range.src_ip("all", "min", "10.10.10.1");

-- prints("linkState", pktgen.linkState("all"));

local file = io.open (stats_file, "w");
file:write("port,duration,pkt_size,rate,mbps,mpps,loss\n");

pktgen.set_range("all", "on");

pktgen.pause("waiting 2 seconds ...\n", 2000);
pktgen.page("0");

for j,pkt_size in ipairs(pkt_sizes) do

  for rate = start_rate,100,1 do

    pktgen.clear("all");
    pktgen.set("all", "rate", rate);
    pktgen.set("all", "size", pkt_size);
    printf("\nsending %dB packets for %d seconds at %.2f %% of line rate ... ", pkt_size, send_for_secs, rate);
    pktgen.start("all");
--    pktgen.start("1");

    local start_time = os.time();
    while os.difftime(os.time(), start_time) < send_for_secs do
      sleep(1);
    end

    pktgen.stop("all");

    printf("traffic stopped. Waiting 5 seconds ...\n");
    sleep(5);

    local stats = pktgen.portStats("all", "port");
    -- prints("portStats raw", stats);

    local min_loss_rate = 100;

    local peer = {1,0,3,2};

    for i=0,3 do
      local peer_port = peer[i+1];
      local missed = stats[peer_port].opackets - stats[i].ipackets;
      if missed + 10  < 0 then
        printf("warning. Received more packets than sent: %f\n", missed);
      end
      if missed < 0 then
        missed = 0;
      end
      local mpps = stats[i].ipackets/1000000/send_for_secs;
      local mbps = 8*stats[i].ibytes/1000000/send_for_secs;
      local loss = 100*missed/stats[peer_port].opackets;
      if loss < min_loss_rate then
        min_loss_rate = loss;
        --      printf("loss=%f min_loss_rate=%f\n", loss, min_loss_rate);
      end
      printf("port %d %dB pkts: %.4f Mbps %.4f Mpps at %.4f%% loss\n", i, pkt_size, mbps, mpps, loss);

      file:write(strfmt("%d,%d,%d,%.4f,%.4f,%.4f,%.4f\n", i, send_for_secs, pkt_size, rate, mbps, mpps, loss));
      file:flush();
    end
    if min_loss_rate > max_loss_rate then
      printf("more than %.3f%% loss rate on all ports. Done.\n", max_loss_rate);
      break
    end

  end

end

file:close();
pktgen.quit();

--   [0] = {
--    ["rx_nombuf"] = 0,                                                                                           
--    ["ibytes"] = 73,
--    ["imissed"] = 0,
--    ["oerrors"] = 0,                                                                                             
--    ["opackets"] = 2237632,
--    ["ierrors"] = 0,
--    ["ipackets"] = 1,
--    ["obytes"] = 134257920,
--  },
--  ["n"] = 4,

