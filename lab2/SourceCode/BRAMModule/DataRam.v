`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB 
// Engineer: Wu Yuzhang
// 
// Design Name: RISCV-Pipline CPU
// Module Name: DataRamWrapper
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: a Verilog-based ram which can be systhesis as BRAM
// 
//////////////////////////////////////////////////////////////////////////////////
//功能说明
    //同步读写bram，a、b双口可读写，a口用于CPU访问dataRam，b口用于外接debug_module进行读写
    //写使能为4bit，支持byte write
//输入
    //clk               输入时钟
    //addra             a口读写地址
    //dina              a口写输入数据
    //wea               a口写使能
    //addrb             b口读写地址
    //dinb              b口写输入数据
    //web               b口写使能
//输出
    //douta             a口读数据
    //doutb             b口读数据
//实验要求  
    //无需修改

module DataRam(
    input  clk,
    input  [ 3:0] wea, web,
    input  [31:2] addra, addrb,
    input  [31:0] dina , dinb,
    output reg [31:0] douta, doutb
);
initial begin douta=0; doutb=0; end

wire addra_valid = ( addra[31:14]==18'h0 );
wire addrb_valid = ( addrb[31:14]==18'h0 );
wire [11:0] addral = addra[13:2];
wire [11:0] addrbl = addrb[13:2];

reg [31:0] ram_cell [0:4095];

initial begin    // 可以把测试数据手动输入此处
    ram_cell[       0] = 32'h0;  // 32'h6141b613;
    ram_cell[       1] = 32'h0;  // 32'h7fe9b631;
    ram_cell[       2] = 32'h0;  // 32'h41851251;
    ram_cell[       3] = 32'h0;  // 32'h70e17a3a;
    ram_cell[       4] = 32'h0;  // 32'hfd8ae97b;
    ram_cell[       5] = 32'h0;  // 32'h63de6762;
    ram_cell[       6] = 32'h0;  // 32'h02afd8a9;
    ram_cell[       7] = 32'h0;  // 32'h53505046;
    ram_cell[       8] = 32'h0;  // 32'h75ed7940;
    ram_cell[       9] = 32'h0;  // 32'hbf9d853a;
    ram_cell[      10] = 32'h0;  // 32'h85f43dc1;
    ram_cell[      11] = 32'h0;  // 32'h218f5fa3;
    ram_cell[      12] = 32'h0;  // 32'hee4a481f;
    ram_cell[      13] = 32'h0;  // 32'h58f7590b;
    ram_cell[      14] = 32'h0;  // 32'h28cc008d;
    ram_cell[      15] = 32'h0;  // 32'h31752c1f;
    ram_cell[      16] = 32'h0;  // 32'h85cf308d;
    ram_cell[      17] = 32'h0;  // 32'he1a67785;
    ram_cell[      18] = 32'h0;  // 32'h1ed5db9c;
    ram_cell[      19] = 32'h0;  // 32'h8b39d881;
    ram_cell[      20] = 32'h0;  // 32'h7cc8121f;
    ram_cell[      21] = 32'h0;  // 32'hd662ccb4;
    ram_cell[      22] = 32'h0;  // 32'ha2c71ff6;
    ram_cell[      23] = 32'h0;  // 32'h8164f566;
    ram_cell[      24] = 32'h0;  // 32'hb7829610;
    ram_cell[      25] = 32'h0;  // 32'h8b6427bc;
    ram_cell[      26] = 32'h0;  // 32'h2a7177bb;
    ram_cell[      27] = 32'h0;  // 32'h9b8753a5;
    ram_cell[      28] = 32'h0;  // 32'h04e6e2d6;
    ram_cell[      29] = 32'h0;  // 32'h7352aa12;
    ram_cell[      30] = 32'h0;  // 32'h91cfd92d;
    ram_cell[      31] = 32'h0;  // 32'h40fd009e;
    ram_cell[      32] = 32'h0;  // 32'h1fdbdad2;
    ram_cell[      33] = 32'h0;  // 32'hba09c1b8;
    ram_cell[      34] = 32'h0;  // 32'hf1828001;
    ram_cell[      35] = 32'h0;  // 32'h991443db;
    ram_cell[      36] = 32'h0;  // 32'h02871ea5;
    ram_cell[      37] = 32'h0;  // 32'h9260040e;
    ram_cell[      38] = 32'h0;  // 32'h0e41f360;
    ram_cell[      39] = 32'h0;  // 32'hcb473849;
    ram_cell[      40] = 32'h0;  // 32'hc794ad76;
    ram_cell[      41] = 32'h0;  // 32'h2fb85bf4;
    ram_cell[      42] = 32'h0;  // 32'h98491b1a;
    ram_cell[      43] = 32'h0;  // 32'h0039a336;
    ram_cell[      44] = 32'h0;  // 32'h3b68f4b5;
    ram_cell[      45] = 32'h0;  // 32'h82cbe83d;
    ram_cell[      46] = 32'h0;  // 32'h46d52fe9;
    ram_cell[      47] = 32'h0;  // 32'hc0590c74;
    ram_cell[      48] = 32'h0;  // 32'h47bc39c7;
    ram_cell[      49] = 32'h0;  // 32'h93203426;
    ram_cell[      50] = 32'h0;  // 32'hfe4760ae;
    ram_cell[      51] = 32'h0;  // 32'h348c46a7;
    ram_cell[      52] = 32'h0;  // 32'he418e736;
    ram_cell[      53] = 32'h0;  // 32'h7afc890f;
    ram_cell[      54] = 32'h0;  // 32'h1760411b;
    ram_cell[      55] = 32'h0;  // 32'h22502a7a;
    ram_cell[      56] = 32'h0;  // 32'hd61d416f;
    ram_cell[      57] = 32'h0;  // 32'h91ad5b54;
    ram_cell[      58] = 32'h0;  // 32'h9cf72c5a;
    ram_cell[      59] = 32'h0;  // 32'hd7c10423;
    ram_cell[      60] = 32'h0;  // 32'hd7127b85;
    ram_cell[      61] = 32'h0;  // 32'h8eb6a299;
    ram_cell[      62] = 32'h0;  // 32'h17422555;
    ram_cell[      63] = 32'h0;  // 32'hd8b9954b;
    ram_cell[      64] = 32'h0;  // 32'h5ac79831;
    ram_cell[      65] = 32'h0;  // 32'hae70e607;
    ram_cell[      66] = 32'h0;  // 32'h0d13638e;
    ram_cell[      67] = 32'h0;  // 32'haad24331;
    ram_cell[      68] = 32'h0;  // 32'h3530c942;
    ram_cell[      69] = 32'h0;  // 32'hd52e32d3;
    ram_cell[      70] = 32'h0;  // 32'hed1dca6d;
    ram_cell[      71] = 32'h0;  // 32'hfda7923e;
    ram_cell[      72] = 32'h0;  // 32'h9c46a701;
    ram_cell[      73] = 32'h0;  // 32'hdd8f6d12;
    ram_cell[      74] = 32'h0;  // 32'h2433a409;
    ram_cell[      75] = 32'h0;  // 32'h6a79ba5d;
    ram_cell[      76] = 32'h0;  // 32'h51473610;
    ram_cell[      77] = 32'h0;  // 32'hd6d90991;
    ram_cell[      78] = 32'h0;  // 32'hdd1bdf2f;
    ram_cell[      79] = 32'h0;  // 32'hefba4bb7;
    ram_cell[      80] = 32'h0;  // 32'h5c7ad181;
    ram_cell[      81] = 32'h0;  // 32'h9ed720ce;
    ram_cell[      82] = 32'h0;  // 32'h2f77ba9a;
    ram_cell[      83] = 32'h0;  // 32'h5cc29fc1;
    ram_cell[      84] = 32'h0;  // 32'hf1ff858a;
    ram_cell[      85] = 32'h0;  // 32'hd0b7a46e;
    ram_cell[      86] = 32'h0;  // 32'ha866cf8c;
    ram_cell[      87] = 32'h0;  // 32'h0d6a3be7;
    ram_cell[      88] = 32'h0;  // 32'h5af09d49;
    ram_cell[      89] = 32'h0;  // 32'hf86cf21c;
    ram_cell[      90] = 32'h0;  // 32'h552c892e;
    ram_cell[      91] = 32'h0;  // 32'h16e9e2de;
    ram_cell[      92] = 32'h0;  // 32'h93e99501;
    ram_cell[      93] = 32'h0;  // 32'h40e5c725;
    ram_cell[      94] = 32'h0;  // 32'ha752aa2a;
    ram_cell[      95] = 32'h0;  // 32'h64c65709;
    ram_cell[      96] = 32'h0;  // 32'hf5f83de8;
    ram_cell[      97] = 32'h0;  // 32'h18cc8fff;
    ram_cell[      98] = 32'h0;  // 32'h474c52cc;
    ram_cell[      99] = 32'h0;  // 32'h301e34b0;
    ram_cell[     100] = 32'h0;  // 32'he7b7396a;
    ram_cell[     101] = 32'h0;  // 32'hd70dd389;
    ram_cell[     102] = 32'h0;  // 32'hac8a5f65;
    ram_cell[     103] = 32'h0;  // 32'h47d9e760;
    ram_cell[     104] = 32'h0;  // 32'h7059ec30;
    ram_cell[     105] = 32'h0;  // 32'h54925fe9;
    ram_cell[     106] = 32'h0;  // 32'ha7ac5068;
    ram_cell[     107] = 32'h0;  // 32'hbc230bcf;
    ram_cell[     108] = 32'h0;  // 32'h6d3e9011;
    ram_cell[     109] = 32'h0;  // 32'h5ae32363;
    ram_cell[     110] = 32'h0;  // 32'h88800c16;
    ram_cell[     111] = 32'h0;  // 32'h007b3852;
    ram_cell[     112] = 32'h0;  // 32'h3f198826;
    ram_cell[     113] = 32'h0;  // 32'h7afd6b44;
    ram_cell[     114] = 32'h0;  // 32'hf30c1d83;
    ram_cell[     115] = 32'h0;  // 32'h9aadc564;
    ram_cell[     116] = 32'h0;  // 32'hdf561117;
    ram_cell[     117] = 32'h0;  // 32'hce9747f7;
    ram_cell[     118] = 32'h0;  // 32'h01754a2d;
    ram_cell[     119] = 32'h0;  // 32'h53350ffe;
    ram_cell[     120] = 32'h0;  // 32'h6f8188d7;
    ram_cell[     121] = 32'h0;  // 32'hd8f7c173;
    ram_cell[     122] = 32'h0;  // 32'h4b3f2850;
    ram_cell[     123] = 32'h0;  // 32'haecf42ea;
    ram_cell[     124] = 32'h0;  // 32'hb871cead;
    ram_cell[     125] = 32'h0;  // 32'hd726f610;
    ram_cell[     126] = 32'h0;  // 32'hdda28c41;
    ram_cell[     127] = 32'h0;  // 32'hfdb6a6c4;
    ram_cell[     128] = 32'h0;  // 32'h55c6b290;
    ram_cell[     129] = 32'h0;  // 32'hb634ac52;
    ram_cell[     130] = 32'h0;  // 32'hefc47e23;
    ram_cell[     131] = 32'h0;  // 32'h9aa0826e;
    ram_cell[     132] = 32'h0;  // 32'haa2859ae;
    ram_cell[     133] = 32'h0;  // 32'h810f1024;
    ram_cell[     134] = 32'h0;  // 32'ha24448d2;
    ram_cell[     135] = 32'h0;  // 32'h45ea1f4a;
    ram_cell[     136] = 32'h0;  // 32'h0024fb27;
    ram_cell[     137] = 32'h0;  // 32'h83b57db9;
    ram_cell[     138] = 32'h0;  // 32'h672d013c;
    ram_cell[     139] = 32'h0;  // 32'h3a331176;
    ram_cell[     140] = 32'h0;  // 32'h06475586;
    ram_cell[     141] = 32'h0;  // 32'h31f138f3;
    ram_cell[     142] = 32'h0;  // 32'h3d7c4070;
    ram_cell[     143] = 32'h0;  // 32'hcbd617b8;
    ram_cell[     144] = 32'h0;  // 32'ha3265b5b;
    ram_cell[     145] = 32'h0;  // 32'ha9647183;
    ram_cell[     146] = 32'h0;  // 32'h11133c55;
    ram_cell[     147] = 32'h0;  // 32'h47a2949e;
    ram_cell[     148] = 32'h0;  // 32'hb6ab034b;
    ram_cell[     149] = 32'h0;  // 32'ha6979585;
    ram_cell[     150] = 32'h0;  // 32'hff9eb9b9;
    ram_cell[     151] = 32'h0;  // 32'hdcf454f4;
    ram_cell[     152] = 32'h0;  // 32'hd9e77ddc;
    ram_cell[     153] = 32'h0;  // 32'hc78ca596;
    ram_cell[     154] = 32'h0;  // 32'h39a0c1f9;
    ram_cell[     155] = 32'h0;  // 32'hc8a7b76f;
    ram_cell[     156] = 32'h0;  // 32'h69b0103f;
    ram_cell[     157] = 32'h0;  // 32'he9c2f79a;
    ram_cell[     158] = 32'h0;  // 32'h91ee809d;
    ram_cell[     159] = 32'h0;  // 32'h1b78e022;
    ram_cell[     160] = 32'h0;  // 32'h8125e6cb;
    ram_cell[     161] = 32'h0;  // 32'hc59cdca2;
    ram_cell[     162] = 32'h0;  // 32'he57572f8;
    ram_cell[     163] = 32'h0;  // 32'ha29f9a1a;
    ram_cell[     164] = 32'h0;  // 32'hb8a6e653;
    ram_cell[     165] = 32'h0;  // 32'h40490a10;
    ram_cell[     166] = 32'h0;  // 32'h124609db;
    ram_cell[     167] = 32'h0;  // 32'h0c5bdbf1;
    ram_cell[     168] = 32'h0;  // 32'h32b2bfcc;
    ram_cell[     169] = 32'h0;  // 32'h2b5e1134;
    ram_cell[     170] = 32'h0;  // 32'hde0b1e95;
    ram_cell[     171] = 32'h0;  // 32'h81cffd01;
    ram_cell[     172] = 32'h0;  // 32'hd2996fd5;
    ram_cell[     173] = 32'h0;  // 32'h9505d7e4;
    ram_cell[     174] = 32'h0;  // 32'h2420e7ec;
    ram_cell[     175] = 32'h0;  // 32'hca9fbb65;
    ram_cell[     176] = 32'h0;  // 32'heb1afc72;
    ram_cell[     177] = 32'h0;  // 32'h880229d7;
    ram_cell[     178] = 32'h0;  // 32'ha27fbe9d;
    ram_cell[     179] = 32'h0;  // 32'ha70b1839;
    ram_cell[     180] = 32'h0;  // 32'h4bab329b;
    ram_cell[     181] = 32'h0;  // 32'hb0aa77eb;
    ram_cell[     182] = 32'h0;  // 32'ha37aa3aa;
    ram_cell[     183] = 32'h0;  // 32'hc6faf3a9;
    ram_cell[     184] = 32'h0;  // 32'h275e61f3;
    ram_cell[     185] = 32'h0;  // 32'h52ad9a4a;
    ram_cell[     186] = 32'h0;  // 32'h6e6a994c;
    ram_cell[     187] = 32'h0;  // 32'hd70bbe69;
    ram_cell[     188] = 32'h0;  // 32'hf570d6cf;
    ram_cell[     189] = 32'h0;  // 32'h8f2f64cd;
    ram_cell[     190] = 32'h0;  // 32'h1082274a;
    ram_cell[     191] = 32'h0;  // 32'hc2448e3a;
    ram_cell[     192] = 32'h0;  // 32'h0be8162c;
    ram_cell[     193] = 32'h0;  // 32'heead6f04;
    ram_cell[     194] = 32'h0;  // 32'hfbd4ed30;
    ram_cell[     195] = 32'h0;  // 32'h3922b06a;
    ram_cell[     196] = 32'h0;  // 32'h73775c81;
    ram_cell[     197] = 32'h0;  // 32'h937c3905;
    ram_cell[     198] = 32'h0;  // 32'h247f8265;
    ram_cell[     199] = 32'h0;  // 32'h9c200500;
    ram_cell[     200] = 32'h0;  // 32'h870a4592;
    ram_cell[     201] = 32'h0;  // 32'h11c2fd35;
    ram_cell[     202] = 32'h0;  // 32'h05a8cdc3;
    ram_cell[     203] = 32'h0;  // 32'hc810ed5e;
    ram_cell[     204] = 32'h0;  // 32'h1179db74;
    ram_cell[     205] = 32'h0;  // 32'h8b688ff4;
    ram_cell[     206] = 32'h0;  // 32'hd77b5b46;
    ram_cell[     207] = 32'h0;  // 32'hbee14ed0;
    ram_cell[     208] = 32'h0;  // 32'hebf8a211;
    ram_cell[     209] = 32'h0;  // 32'h5a9c4862;
    ram_cell[     210] = 32'h0;  // 32'h1c9df750;
    ram_cell[     211] = 32'h0;  // 32'h1b28e718;
    ram_cell[     212] = 32'h0;  // 32'hababc6db;
    ram_cell[     213] = 32'h0;  // 32'h3831f7c0;
    ram_cell[     214] = 32'h0;  // 32'h8ac0bd95;
    ram_cell[     215] = 32'h0;  // 32'h81725b1e;
    ram_cell[     216] = 32'h0;  // 32'h287410c7;
    ram_cell[     217] = 32'h0;  // 32'h28b13f49;
    ram_cell[     218] = 32'h0;  // 32'h8c856c7f;
    ram_cell[     219] = 32'h0;  // 32'hca21fbdc;
    ram_cell[     220] = 32'h0;  // 32'h917360a1;
    ram_cell[     221] = 32'h0;  // 32'h7d5c7a4b;
    ram_cell[     222] = 32'h0;  // 32'hfe932a9f;
    ram_cell[     223] = 32'h0;  // 32'h30879970;
    ram_cell[     224] = 32'h0;  // 32'hfdee7418;
    ram_cell[     225] = 32'h0;  // 32'h25795f25;
    ram_cell[     226] = 32'h0;  // 32'h63ef7309;
    ram_cell[     227] = 32'h0;  // 32'h780ee382;
    ram_cell[     228] = 32'h0;  // 32'h3760acd3;
    ram_cell[     229] = 32'h0;  // 32'h2a759e42;
    ram_cell[     230] = 32'h0;  // 32'h9abaa263;
    ram_cell[     231] = 32'h0;  // 32'h92c31b5f;
    ram_cell[     232] = 32'h0;  // 32'hc410d8fa;
    ram_cell[     233] = 32'h0;  // 32'h0b1f9def;
    ram_cell[     234] = 32'h0;  // 32'h34e3ac87;
    ram_cell[     235] = 32'h0;  // 32'hf4b7f078;
    ram_cell[     236] = 32'h0;  // 32'h07d3d011;
    ram_cell[     237] = 32'h0;  // 32'h7a93278e;
    ram_cell[     238] = 32'h0;  // 32'ha907b75b;
    ram_cell[     239] = 32'h0;  // 32'hd72beb28;
    ram_cell[     240] = 32'h0;  // 32'hde266d60;
    ram_cell[     241] = 32'h0;  // 32'h8851b957;
    ram_cell[     242] = 32'h0;  // 32'h285da882;
    ram_cell[     243] = 32'h0;  // 32'h90993fc6;
    ram_cell[     244] = 32'h0;  // 32'hd5ef2ba2;
    ram_cell[     245] = 32'h0;  // 32'h40147dd1;
    ram_cell[     246] = 32'h0;  // 32'h9b01d727;
    ram_cell[     247] = 32'h0;  // 32'h212f091c;
    ram_cell[     248] = 32'h0;  // 32'h7001dd6e;
    ram_cell[     249] = 32'h0;  // 32'hc0e1366b;
    ram_cell[     250] = 32'h0;  // 32'hdebef948;
    ram_cell[     251] = 32'h0;  // 32'h7232fac4;
    ram_cell[     252] = 32'h0;  // 32'he553ad02;
    ram_cell[     253] = 32'h0;  // 32'h922b3285;
    ram_cell[     254] = 32'h0;  // 32'h1aa9c769;
    ram_cell[     255] = 32'h0;  // 32'h70d411cf;
    // src matrix A
    ram_cell[     256] = 32'he1634cff;
    ram_cell[     257] = 32'hacb1c4d1;
    ram_cell[     258] = 32'h7d050a86;
    ram_cell[     259] = 32'h976a496e;
    ram_cell[     260] = 32'hd82a87e7;
    ram_cell[     261] = 32'hfcc49a58;
    ram_cell[     262] = 32'hd2f130ad;
    ram_cell[     263] = 32'he7a5faa0;
    ram_cell[     264] = 32'h8a2c87dd;
    ram_cell[     265] = 32'h0e77a600;
    ram_cell[     266] = 32'hd2d6ea82;
    ram_cell[     267] = 32'hf0c9c189;
    ram_cell[     268] = 32'h78b6527d;
    ram_cell[     269] = 32'h12be1f1f;
    ram_cell[     270] = 32'h4b5a5882;
    ram_cell[     271] = 32'h70c40eed;
    ram_cell[     272] = 32'h4f6b8714;
    ram_cell[     273] = 32'hb193a421;
    ram_cell[     274] = 32'hbd4e44a2;
    ram_cell[     275] = 32'h76bc373d;
    ram_cell[     276] = 32'hf0b7382c;
    ram_cell[     277] = 32'h2377b359;
    ram_cell[     278] = 32'h35a6c2b8;
    ram_cell[     279] = 32'h69053b23;
    ram_cell[     280] = 32'hcf71f34d;
    ram_cell[     281] = 32'h6bec9c7b;
    ram_cell[     282] = 32'h59ce2edd;
    ram_cell[     283] = 32'h09daeb50;
    ram_cell[     284] = 32'hdbe6081d;
    ram_cell[     285] = 32'he2f32b45;
    ram_cell[     286] = 32'hf4c7036c;
    ram_cell[     287] = 32'hdf67a15e;
    ram_cell[     288] = 32'h6d66f3ab;
    ram_cell[     289] = 32'h760882c2;
    ram_cell[     290] = 32'h05f8f675;
    ram_cell[     291] = 32'h4bff34f7;
    ram_cell[     292] = 32'h58f6d90e;
    ram_cell[     293] = 32'hb3088883;
    ram_cell[     294] = 32'h56b86d82;
    ram_cell[     295] = 32'hffb167e2;
    ram_cell[     296] = 32'ha35c8fd2;
    ram_cell[     297] = 32'h5694870c;
    ram_cell[     298] = 32'hdf802f60;
    ram_cell[     299] = 32'h94bc2a31;
    ram_cell[     300] = 32'h9e0df2b5;
    ram_cell[     301] = 32'hb21815a3;
    ram_cell[     302] = 32'hfba54b8c;
    ram_cell[     303] = 32'hce09c17b;
    ram_cell[     304] = 32'h1f4d3258;
    ram_cell[     305] = 32'h0add0975;
    ram_cell[     306] = 32'hba787264;
    ram_cell[     307] = 32'hd168766c;
    ram_cell[     308] = 32'h2af0b9f1;
    ram_cell[     309] = 32'hbfc846ac;
    ram_cell[     310] = 32'haae48473;
    ram_cell[     311] = 32'h2b853ea4;
    ram_cell[     312] = 32'h88aa27c2;
    ram_cell[     313] = 32'hd65f0f5c;
    ram_cell[     314] = 32'h8f52d30b;
    ram_cell[     315] = 32'ha092df2f;
    ram_cell[     316] = 32'h640a4c0e;
    ram_cell[     317] = 32'h484f11b3;
    ram_cell[     318] = 32'hf3638c5c;
    ram_cell[     319] = 32'h04d581c9;
    ram_cell[     320] = 32'he6a60fec;
    ram_cell[     321] = 32'h1fa85fc4;
    ram_cell[     322] = 32'hb8c193c2;
    ram_cell[     323] = 32'hf7f1cc8d;
    ram_cell[     324] = 32'hb1b6b59c;
    ram_cell[     325] = 32'he8271230;
    ram_cell[     326] = 32'h2330e724;
    ram_cell[     327] = 32'h7a3a0af2;
    ram_cell[     328] = 32'he39a155c;
    ram_cell[     329] = 32'h722a8f8e;
    ram_cell[     330] = 32'h8d9e8d7a;
    ram_cell[     331] = 32'hde7200e2;
    ram_cell[     332] = 32'h8a3edc19;
    ram_cell[     333] = 32'h5d047d5f;
    ram_cell[     334] = 32'h54bd38e7;
    ram_cell[     335] = 32'h44be1611;
    ram_cell[     336] = 32'hd9b54e6d;
    ram_cell[     337] = 32'ha9ba81f2;
    ram_cell[     338] = 32'hc764c135;
    ram_cell[     339] = 32'h434a06b0;
    ram_cell[     340] = 32'h0944524f;
    ram_cell[     341] = 32'h51402a48;
    ram_cell[     342] = 32'h237ac608;
    ram_cell[     343] = 32'he2c4c836;
    ram_cell[     344] = 32'hdc996646;
    ram_cell[     345] = 32'h557e20e5;
    ram_cell[     346] = 32'hcf6f4daf;
    ram_cell[     347] = 32'hd49bc126;
    ram_cell[     348] = 32'h40938141;
    ram_cell[     349] = 32'hf5de59dc;
    ram_cell[     350] = 32'hca7795e4;
    ram_cell[     351] = 32'h5eaea5b0;
    ram_cell[     352] = 32'h31030819;
    ram_cell[     353] = 32'h325da8f4;
    ram_cell[     354] = 32'h96daea41;
    ram_cell[     355] = 32'h893c6088;
    ram_cell[     356] = 32'h6d49a890;
    ram_cell[     357] = 32'ha6c2f293;
    ram_cell[     358] = 32'h7307e719;
    ram_cell[     359] = 32'hf17f6214;
    ram_cell[     360] = 32'hbf721b88;
    ram_cell[     361] = 32'h34c3760d;
    ram_cell[     362] = 32'h2e352002;
    ram_cell[     363] = 32'h928a6472;
    ram_cell[     364] = 32'h6c7953bd;
    ram_cell[     365] = 32'h8e5deb4f;
    ram_cell[     366] = 32'h7d636e52;
    ram_cell[     367] = 32'h06349448;
    ram_cell[     368] = 32'h9ea9d2d3;
    ram_cell[     369] = 32'h6e8e54ba;
    ram_cell[     370] = 32'h5213913d;
    ram_cell[     371] = 32'hd725ac0a;
    ram_cell[     372] = 32'hcd118d09;
    ram_cell[     373] = 32'h242c3503;
    ram_cell[     374] = 32'h209eb3a5;
    ram_cell[     375] = 32'hae003237;
    ram_cell[     376] = 32'h03776206;
    ram_cell[     377] = 32'h8bb2377c;
    ram_cell[     378] = 32'hac692af8;
    ram_cell[     379] = 32'hfcde95ec;
    ram_cell[     380] = 32'h7f48ccb0;
    ram_cell[     381] = 32'h12b2a775;
    ram_cell[     382] = 32'hb198ee34;
    ram_cell[     383] = 32'h4bd90181;
    ram_cell[     384] = 32'hebacc7ed;
    ram_cell[     385] = 32'h3b18995d;
    ram_cell[     386] = 32'h0b3e1194;
    ram_cell[     387] = 32'h0709ef80;
    ram_cell[     388] = 32'hbf408289;
    ram_cell[     389] = 32'h8f1ee3b3;
    ram_cell[     390] = 32'h95a7d780;
    ram_cell[     391] = 32'h1f069c9e;
    ram_cell[     392] = 32'hf1bd1282;
    ram_cell[     393] = 32'hb1f3f278;
    ram_cell[     394] = 32'h5e4a767a;
    ram_cell[     395] = 32'hf309d121;
    ram_cell[     396] = 32'h4c05e608;
    ram_cell[     397] = 32'he6f31c9a;
    ram_cell[     398] = 32'h6402773f;
    ram_cell[     399] = 32'h04ab39f8;
    ram_cell[     400] = 32'hfb2a1177;
    ram_cell[     401] = 32'h3fd80439;
    ram_cell[     402] = 32'h9033e387;
    ram_cell[     403] = 32'h26406b50;
    ram_cell[     404] = 32'hc382a94e;
    ram_cell[     405] = 32'h76ad203e;
    ram_cell[     406] = 32'h01bc1ca3;
    ram_cell[     407] = 32'hf0d5740f;
    ram_cell[     408] = 32'h568aaf43;
    ram_cell[     409] = 32'hd15b0a6b;
    ram_cell[     410] = 32'h801a395e;
    ram_cell[     411] = 32'hc95b13cb;
    ram_cell[     412] = 32'ha993e315;
    ram_cell[     413] = 32'hf7258eaa;
    ram_cell[     414] = 32'h9e847f34;
    ram_cell[     415] = 32'hb53a8dd6;
    ram_cell[     416] = 32'h549171c3;
    ram_cell[     417] = 32'hf08ad311;
    ram_cell[     418] = 32'he840f4b9;
    ram_cell[     419] = 32'h419c9d70;
    ram_cell[     420] = 32'h40c81857;
    ram_cell[     421] = 32'h1365468d;
    ram_cell[     422] = 32'he2fbe535;
    ram_cell[     423] = 32'h75fbf1c4;
    ram_cell[     424] = 32'h1fe1eaa8;
    ram_cell[     425] = 32'h824fd8a5;
    ram_cell[     426] = 32'hd65acec0;
    ram_cell[     427] = 32'h5cdfe4c3;
    ram_cell[     428] = 32'hfbb20617;
    ram_cell[     429] = 32'h940213d3;
    ram_cell[     430] = 32'h3581fab1;
    ram_cell[     431] = 32'hf5d14c1e;
    ram_cell[     432] = 32'h9cc7b2ed;
    ram_cell[     433] = 32'h2ee3d228;
    ram_cell[     434] = 32'hb2c97ab5;
    ram_cell[     435] = 32'h7daf9280;
    ram_cell[     436] = 32'h73941bc8;
    ram_cell[     437] = 32'h3eb6b072;
    ram_cell[     438] = 32'h2a14034a;
    ram_cell[     439] = 32'h75f6da52;
    ram_cell[     440] = 32'hee9b726a;
    ram_cell[     441] = 32'h6af83b4d;
    ram_cell[     442] = 32'h24173de9;
    ram_cell[     443] = 32'h3d266525;
    ram_cell[     444] = 32'h317568ae;
    ram_cell[     445] = 32'h17c1eabc;
    ram_cell[     446] = 32'h0a84363c;
    ram_cell[     447] = 32'hd80d2f44;
    ram_cell[     448] = 32'h7a112db5;
    ram_cell[     449] = 32'h117c6bb8;
    ram_cell[     450] = 32'h47663035;
    ram_cell[     451] = 32'hdad2c34d;
    ram_cell[     452] = 32'he719e92b;
    ram_cell[     453] = 32'h726f43c3;
    ram_cell[     454] = 32'h0f75b8a8;
    ram_cell[     455] = 32'hcd016a52;
    ram_cell[     456] = 32'hfb4d5d04;
    ram_cell[     457] = 32'h8f7970e0;
    ram_cell[     458] = 32'h2f25eb2d;
    ram_cell[     459] = 32'ha30dd217;
    ram_cell[     460] = 32'he5e07df6;
    ram_cell[     461] = 32'h988eb00e;
    ram_cell[     462] = 32'hab704eaa;
    ram_cell[     463] = 32'hd44ba174;
    ram_cell[     464] = 32'h40239d0a;
    ram_cell[     465] = 32'h20355b1f;
    ram_cell[     466] = 32'h827ab66d;
    ram_cell[     467] = 32'h20008b05;
    ram_cell[     468] = 32'h3be6168d;
    ram_cell[     469] = 32'h2c56dcd4;
    ram_cell[     470] = 32'hee3b476a;
    ram_cell[     471] = 32'h9fe9a831;
    ram_cell[     472] = 32'h90103897;
    ram_cell[     473] = 32'hf33aec7a;
    ram_cell[     474] = 32'h5093c06e;
    ram_cell[     475] = 32'h2741a97c;
    ram_cell[     476] = 32'hc192975d;
    ram_cell[     477] = 32'hbfefb39c;
    ram_cell[     478] = 32'h989a4ead;
    ram_cell[     479] = 32'h5c407901;
    ram_cell[     480] = 32'h63e88174;
    ram_cell[     481] = 32'h0acca225;
    ram_cell[     482] = 32'h970f9589;
    ram_cell[     483] = 32'hf8cb1be1;
    ram_cell[     484] = 32'h056522ce;
    ram_cell[     485] = 32'hbdb9e21d;
    ram_cell[     486] = 32'h95053906;
    ram_cell[     487] = 32'hf95f2b7f;
    ram_cell[     488] = 32'h6fe3ecc4;
    ram_cell[     489] = 32'hf23c6bfd;
    ram_cell[     490] = 32'h49da96f6;
    ram_cell[     491] = 32'h76e70687;
    ram_cell[     492] = 32'he015b24b;
    ram_cell[     493] = 32'h4d133327;
    ram_cell[     494] = 32'h266fbfe8;
    ram_cell[     495] = 32'hd6b67306;
    ram_cell[     496] = 32'h7eeccf0f;
    ram_cell[     497] = 32'h2b90904a;
    ram_cell[     498] = 32'h0cedc77d;
    ram_cell[     499] = 32'h7551b9a6;
    ram_cell[     500] = 32'hfa984c1b;
    ram_cell[     501] = 32'h4e83d065;
    ram_cell[     502] = 32'hb0852b62;
    ram_cell[     503] = 32'hea955613;
    ram_cell[     504] = 32'he401e356;
    ram_cell[     505] = 32'h77c799d6;
    ram_cell[     506] = 32'hfadbf0dc;
    ram_cell[     507] = 32'hd555e71b;
    ram_cell[     508] = 32'hf6259554;
    ram_cell[     509] = 32'h051e9bd8;
    ram_cell[     510] = 32'h8cc2aac3;
    ram_cell[     511] = 32'hfeec8165;
    // src matrix B
    ram_cell[     512] = 32'h2ef1544e;
    ram_cell[     513] = 32'h50444fc9;
    ram_cell[     514] = 32'h0c258ef3;
    ram_cell[     515] = 32'hc70d283f;
    ram_cell[     516] = 32'heb54eba0;
    ram_cell[     517] = 32'h61dd3cd4;
    ram_cell[     518] = 32'h0d53218c;
    ram_cell[     519] = 32'hb3647a77;
    ram_cell[     520] = 32'hc4c95724;
    ram_cell[     521] = 32'he48a2ee8;
    ram_cell[     522] = 32'h30a5f106;
    ram_cell[     523] = 32'hdf9dd6f5;
    ram_cell[     524] = 32'hdde208ca;
    ram_cell[     525] = 32'h703e6135;
    ram_cell[     526] = 32'h45d32fb4;
    ram_cell[     527] = 32'hed1d8b72;
    ram_cell[     528] = 32'h7a4e9923;
    ram_cell[     529] = 32'h610e7d88;
    ram_cell[     530] = 32'h27851b88;
    ram_cell[     531] = 32'h7d6b6cb7;
    ram_cell[     532] = 32'hb23755dd;
    ram_cell[     533] = 32'h84a0e477;
    ram_cell[     534] = 32'h94aa73c0;
    ram_cell[     535] = 32'h1f5535cd;
    ram_cell[     536] = 32'heac01457;
    ram_cell[     537] = 32'hd5ee842c;
    ram_cell[     538] = 32'h105012ec;
    ram_cell[     539] = 32'habfd260c;
    ram_cell[     540] = 32'hb9692a9e;
    ram_cell[     541] = 32'h4daeb54a;
    ram_cell[     542] = 32'h98c27f28;
    ram_cell[     543] = 32'h6eaccc78;
    ram_cell[     544] = 32'he9534756;
    ram_cell[     545] = 32'h83deb7c0;
    ram_cell[     546] = 32'h7a2e94de;
    ram_cell[     547] = 32'h8373978c;
    ram_cell[     548] = 32'haa4f2e4d;
    ram_cell[     549] = 32'h04882b2b;
    ram_cell[     550] = 32'h29d4f68c;
    ram_cell[     551] = 32'haf1a852a;
    ram_cell[     552] = 32'h2c9e9120;
    ram_cell[     553] = 32'he5e1d74b;
    ram_cell[     554] = 32'hac2507d8;
    ram_cell[     555] = 32'ha4ba3667;
    ram_cell[     556] = 32'hcbb390a5;
    ram_cell[     557] = 32'hd55a5209;
    ram_cell[     558] = 32'hb2729b80;
    ram_cell[     559] = 32'hcb57e715;
    ram_cell[     560] = 32'h435331f7;
    ram_cell[     561] = 32'h778cdab5;
    ram_cell[     562] = 32'h5bed6dad;
    ram_cell[     563] = 32'h81af58ab;
    ram_cell[     564] = 32'h22768b6b;
    ram_cell[     565] = 32'he68951ea;
    ram_cell[     566] = 32'hcaa98ab4;
    ram_cell[     567] = 32'hcadd9d3e;
    ram_cell[     568] = 32'h45f0c7b2;
    ram_cell[     569] = 32'h15b1e573;
    ram_cell[     570] = 32'h900e979e;
    ram_cell[     571] = 32'h1df33244;
    ram_cell[     572] = 32'h53bf0ec2;
    ram_cell[     573] = 32'h5aa5e6ad;
    ram_cell[     574] = 32'ha4617b8f;
    ram_cell[     575] = 32'hf130b5df;
    ram_cell[     576] = 32'hd6b38ca2;
    ram_cell[     577] = 32'h19ae0569;
    ram_cell[     578] = 32'h4bc755ae;
    ram_cell[     579] = 32'h86d2555f;
    ram_cell[     580] = 32'h0c949237;
    ram_cell[     581] = 32'hfd2c2f6d;
    ram_cell[     582] = 32'h52027853;
    ram_cell[     583] = 32'heb4f2ece;
    ram_cell[     584] = 32'h68914373;
    ram_cell[     585] = 32'had3f17ac;
    ram_cell[     586] = 32'h5bc24f21;
    ram_cell[     587] = 32'h0f043c4e;
    ram_cell[     588] = 32'hb8e9fbaa;
    ram_cell[     589] = 32'hebc6cd28;
    ram_cell[     590] = 32'ha96739e8;
    ram_cell[     591] = 32'h05aa187e;
    ram_cell[     592] = 32'hdc7696cd;
    ram_cell[     593] = 32'h3f560306;
    ram_cell[     594] = 32'hc2689286;
    ram_cell[     595] = 32'hdb3eb9c1;
    ram_cell[     596] = 32'ha13c8e97;
    ram_cell[     597] = 32'h38e24211;
    ram_cell[     598] = 32'h4c6606e8;
    ram_cell[     599] = 32'h6456a0f4;
    ram_cell[     600] = 32'hc29c130d;
    ram_cell[     601] = 32'h08d083e2;
    ram_cell[     602] = 32'h18bc61c1;
    ram_cell[     603] = 32'h5833a61d;
    ram_cell[     604] = 32'hec4e6bd4;
    ram_cell[     605] = 32'h354abda7;
    ram_cell[     606] = 32'h301c9558;
    ram_cell[     607] = 32'h6d70bbd5;
    ram_cell[     608] = 32'hc837d71b;
    ram_cell[     609] = 32'h262d40f8;
    ram_cell[     610] = 32'h731a7a46;
    ram_cell[     611] = 32'h8b30189c;
    ram_cell[     612] = 32'h711dea5f;
    ram_cell[     613] = 32'h10a6f809;
    ram_cell[     614] = 32'h31298975;
    ram_cell[     615] = 32'h151dd504;
    ram_cell[     616] = 32'h70488921;
    ram_cell[     617] = 32'h36c81377;
    ram_cell[     618] = 32'hebff61a0;
    ram_cell[     619] = 32'he39432a0;
    ram_cell[     620] = 32'hbb96eac4;
    ram_cell[     621] = 32'h8390ef42;
    ram_cell[     622] = 32'hb7b99616;
    ram_cell[     623] = 32'h94d0005c;
    ram_cell[     624] = 32'h0bc2f3cb;
    ram_cell[     625] = 32'ha2a76f56;
    ram_cell[     626] = 32'h32d46392;
    ram_cell[     627] = 32'he7a019b4;
    ram_cell[     628] = 32'h887cf9b5;
    ram_cell[     629] = 32'hf713ac75;
    ram_cell[     630] = 32'hffd8ebfa;
    ram_cell[     631] = 32'hf52092f1;
    ram_cell[     632] = 32'h96821c4e;
    ram_cell[     633] = 32'h00deabf5;
    ram_cell[     634] = 32'hd07fea4c;
    ram_cell[     635] = 32'h8d1f23e5;
    ram_cell[     636] = 32'hf3a8a628;
    ram_cell[     637] = 32'h6d559fd4;
    ram_cell[     638] = 32'hbc5bfb03;
    ram_cell[     639] = 32'hb0675260;
    ram_cell[     640] = 32'ha4b7ee63;
    ram_cell[     641] = 32'h26b00b51;
    ram_cell[     642] = 32'h5821de03;
    ram_cell[     643] = 32'h7231e677;
    ram_cell[     644] = 32'h7a7af904;
    ram_cell[     645] = 32'hf77d6597;
    ram_cell[     646] = 32'h00690499;
    ram_cell[     647] = 32'h2ee516b8;
    ram_cell[     648] = 32'h13fd2a96;
    ram_cell[     649] = 32'h6e45145d;
    ram_cell[     650] = 32'hde011a63;
    ram_cell[     651] = 32'h6dbb488b;
    ram_cell[     652] = 32'h4707d33d;
    ram_cell[     653] = 32'h2bf061cd;
    ram_cell[     654] = 32'h3b645a29;
    ram_cell[     655] = 32'h72600ee2;
    ram_cell[     656] = 32'h36b8e7ee;
    ram_cell[     657] = 32'h6da08f59;
    ram_cell[     658] = 32'h67751662;
    ram_cell[     659] = 32'h2790d5e8;
    ram_cell[     660] = 32'h13082489;
    ram_cell[     661] = 32'h56a9450a;
    ram_cell[     662] = 32'hb606a8a2;
    ram_cell[     663] = 32'h89647ec7;
    ram_cell[     664] = 32'heeac3c87;
    ram_cell[     665] = 32'h07054756;
    ram_cell[     666] = 32'h19f371f3;
    ram_cell[     667] = 32'h4de177f6;
    ram_cell[     668] = 32'h7e244cb5;
    ram_cell[     669] = 32'h9daa4c3b;
    ram_cell[     670] = 32'h774b0aa7;
    ram_cell[     671] = 32'hc8c82d52;
    ram_cell[     672] = 32'hbe97ab52;
    ram_cell[     673] = 32'hc7726173;
    ram_cell[     674] = 32'hff7e8e79;
    ram_cell[     675] = 32'ha09b970d;
    ram_cell[     676] = 32'hd483828e;
    ram_cell[     677] = 32'hb8ee04bc;
    ram_cell[     678] = 32'hf9d390ed;
    ram_cell[     679] = 32'ha8083dfd;
    ram_cell[     680] = 32'h651871be;
    ram_cell[     681] = 32'h6f77fa74;
    ram_cell[     682] = 32'h4dbb332e;
    ram_cell[     683] = 32'h58a8a064;
    ram_cell[     684] = 32'h9e4e3653;
    ram_cell[     685] = 32'h21005559;
    ram_cell[     686] = 32'h14036fba;
    ram_cell[     687] = 32'hc17738b0;
    ram_cell[     688] = 32'haf4d756a;
    ram_cell[     689] = 32'hc164d5ca;
    ram_cell[     690] = 32'hade91207;
    ram_cell[     691] = 32'h40d13079;
    ram_cell[     692] = 32'h25c7af57;
    ram_cell[     693] = 32'h4ef4e9c8;
    ram_cell[     694] = 32'h18af0c6b;
    ram_cell[     695] = 32'hb7967f8a;
    ram_cell[     696] = 32'h31d6df88;
    ram_cell[     697] = 32'he73e0563;
    ram_cell[     698] = 32'h05615485;
    ram_cell[     699] = 32'h38cb2a35;
    ram_cell[     700] = 32'h106a22c0;
    ram_cell[     701] = 32'h4d730fdf;
    ram_cell[     702] = 32'h6d42d571;
    ram_cell[     703] = 32'h3469d9b9;
    ram_cell[     704] = 32'he0c46b6d;
    ram_cell[     705] = 32'hae37daec;
    ram_cell[     706] = 32'hff85b18e;
    ram_cell[     707] = 32'he6cbe0c0;
    ram_cell[     708] = 32'h238629cd;
    ram_cell[     709] = 32'ha94f44a0;
    ram_cell[     710] = 32'h3da53536;
    ram_cell[     711] = 32'h63a4a886;
    ram_cell[     712] = 32'he9737d5f;
    ram_cell[     713] = 32'hfba8ccdd;
    ram_cell[     714] = 32'he278151c;
    ram_cell[     715] = 32'h875d2d5c;
    ram_cell[     716] = 32'h4219198c;
    ram_cell[     717] = 32'h988b36ed;
    ram_cell[     718] = 32'h20004ff5;
    ram_cell[     719] = 32'h3d5344ce;
    ram_cell[     720] = 32'h59b6ff61;
    ram_cell[     721] = 32'h768dae67;
    ram_cell[     722] = 32'h27254e53;
    ram_cell[     723] = 32'hcee083dc;
    ram_cell[     724] = 32'h9d76fc5b;
    ram_cell[     725] = 32'h7176bb4e;
    ram_cell[     726] = 32'h17f8b4ae;
    ram_cell[     727] = 32'h0c2a7fe0;
    ram_cell[     728] = 32'hc45602fa;
    ram_cell[     729] = 32'h9c1c3a62;
    ram_cell[     730] = 32'hc64962a0;
    ram_cell[     731] = 32'h906eed9c;
    ram_cell[     732] = 32'h2d9fe999;
    ram_cell[     733] = 32'h6a5bcaba;
    ram_cell[     734] = 32'hb7dfc0e0;
    ram_cell[     735] = 32'h556a254a;
    ram_cell[     736] = 32'ha174f908;
    ram_cell[     737] = 32'h72377224;
    ram_cell[     738] = 32'hbc077af5;
    ram_cell[     739] = 32'ha793c317;
    ram_cell[     740] = 32'h7b2e7288;
    ram_cell[     741] = 32'h7d5f4559;
    ram_cell[     742] = 32'h8e777544;
    ram_cell[     743] = 32'h11c5b698;
    ram_cell[     744] = 32'h067e1ff8;
    ram_cell[     745] = 32'h65623584;
    ram_cell[     746] = 32'h4459d011;
    ram_cell[     747] = 32'hb4747fc1;
    ram_cell[     748] = 32'h0e3ebe2c;
    ram_cell[     749] = 32'ha41d941c;
    ram_cell[     750] = 32'h1c26c867;
    ram_cell[     751] = 32'hdcd73586;
    ram_cell[     752] = 32'h17f5c53c;
    ram_cell[     753] = 32'h01e36def;
    ram_cell[     754] = 32'h125b3563;
    ram_cell[     755] = 32'h1a257d4d;
    ram_cell[     756] = 32'he87d3f49;
    ram_cell[     757] = 32'h9e23c378;
    ram_cell[     758] = 32'h89983611;
    ram_cell[     759] = 32'hb1107a02;
    ram_cell[     760] = 32'h90e3ff88;
    ram_cell[     761] = 32'hcb4c0c18;
    ram_cell[     762] = 32'hc050a09e;
    ram_cell[     763] = 32'h37b3ee56;
    ram_cell[     764] = 32'hb7803bb7;
    ram_cell[     765] = 32'h3f2c97ff;
    ram_cell[     766] = 32'h8b8ca70c;
    ram_cell[     767] = 32'ha8c2949a;
    // ......
end

always @ (posedge clk)
    douta <= addra_valid ? ram_cell[addral] : 0;
    
always @ (posedge clk)
    doutb <= addrb_valid ? ram_cell[addrbl] : 0;

always @ (posedge clk)
    if(wea[0] & addra_valid) 
        ram_cell[addral][ 7: 0] <= dina[ 7: 0];
        
always @ (posedge clk)
    if(wea[1] & addra_valid) 
        ram_cell[addral][15: 8] <= dina[15: 8];
        
always @ (posedge clk)
    if(wea[2] & addra_valid) 
        ram_cell[addral][23:16] <= dina[23:16];
        
always @ (posedge clk)
    if(wea[3] & addra_valid) 
        ram_cell[addral][31:24] <= dina[31:24];
        
always @ (posedge clk)
    if(web[0] & addrb_valid) 
        ram_cell[addrbl][ 7: 0] <= dinb[ 7: 0];
                
always @ (posedge clk)
    if(web[1] & addrb_valid) 
        ram_cell[addrbl][15: 8] <= dinb[15: 8];
                
always @ (posedge clk)
    if(web[2] & addrb_valid) 
        ram_cell[addrbl][23:16] <= dinb[23:16];
                
always @ (posedge clk)
    if(web[3] & addrb_valid) 
        ram_cell[addrbl][31:24] <= dinb[31:24];

endmodule
