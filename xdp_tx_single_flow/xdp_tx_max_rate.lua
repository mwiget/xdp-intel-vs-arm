-- test.lua
--

package.path = package.path ..";?.lua;pktgen-21.02.0/?.lua;"

require "Pktgen";
require "Perf";

pktgen.set_mac(0, "dst", "b8:ce:f6:44:d1:e2");
pktgen.set_mac(1, "dst", "b8:ce:f6:44:d1:e3");
pktgen.set_mac(2, "dst", "04:3f:72:ad:1d:7e");
pktgen.set_mac(3, "dst", "04:3f:72:ad:1d:7f");

local stats_file = "stats.csv";

local send_for_secs = 60;
local max_loss_rate = 0.1;
local start_rate = 1;
local pkt_sizes = { 64,128,256,512,1024 };

pktgen.set("all", "size", 64);

pktgen.set_proto("all", "udp");
pktgen.set("all", "sport", 1234);
pktgen.set("all", "dport", 5678);
pktgen.set("all", "ttl", 64);

pktgen.set_ipaddr(0, "dst", "198.18.0.85");
pktgen.set_ipaddr(1, "dst", "198.18.128.85");
pktgen.set_ipaddr(2, "dst", "198.19.0.85");
pktgen.set_ipaddr(3, "dst", "198.19.128.85");

pktgen.set_ipaddr("all", "src", "10.10.10.10/24");

-- prints("linkState", pktgen.linkState("all"));

local file = io.open (stats_file, "w");
file:write("# port,duration,pkt_size,rate,mbps,mpps,loss\n");

for j,pkt_size in ipairs(pkt_sizes) do

  for rate = start_rate,100,1 do

    pktgen.clear("all");
    pktgen.set("all", "rate", rate);
    pktgen.set("all", "size", pkt_size);
    printf("\nsending %dB packets for %d seconds at %.2f %% of line rate ... ", pkt_size, send_for_secs, rate);
    pktgen.start("all");

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

    for i=0,3 do
      local missed = stats[i].opackets - stats[i].ipackets;
      if missed + 10  < 0 then
        printf("warning. Received more packets than sent: %f\n", missed);
      end
      if missed < 0 then
        missed = 0;
      end
      local mpps = stats[i].ipackets/1000000/send_for_secs;
      local mbps = 8*stats[i].ibytes/1000000/send_for_secs;
      local loss = 100*missed/stats[i].opackets;
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

