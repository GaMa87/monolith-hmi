// =====================================================================
//  ESP32-S3 HMI ENCLOSURE  —  "MONOLITH"  (tilted front, wedge body)
//  ESP32-S3-DevKitC-1 · 2.8" ILI9341 SPI TFT · HW-040 rotary encoder modul
//  · Back touch (TTP223 capacitive) · 12 V DC panel jack (+ buck 12V→5V)
//  · ZS-042 (DS3231 RTC) · AHT10 (temp/RH, za lastno rešetko v rear cover)
//
//  Multi-part FDM: front bezel · main body · rear cover · knob · touch clip.
//   Vse je parametrično — ⚠ označene mere IZMERI na svojih
//  modulih (TFT moduli različnih proizvajalcev se razlikujejo za ±1–2 mm).
//
//  NAKLON: `tilt` nagne celoten sprednji modul (bezel + TFT + HW-040 + tipka)
//  nazaj okoli spodnjega roba. Body postane wedge: ravno dno, ravna streha,
//  navpična zadnja stran; sprednji "collar" body-ja sledi naklonu, zato snap-fiti
//  in vse mere sprednjega modula ostanejo enake pri vsakem kotu. tilt = 0 → škatla.
//
//  OpenSCAD ≥ 2021.01  (2024.x+ z Manifold backend je bistveno hitrejši pri F6/STL)
// =====================================================================
//
//  POGLEDI  (spremenljivka `part`, ali v Customizer panelu):
//    "exploded"  exploded view s komponentami in osmi montaže (privzeto)
//    "assembly"  sestavljeno ohišje s komponentami
//    "section"   navpični rez pri x = section_x (side profile, preveri zračnosti)
//    "bezel" | "body" | "rear" | "knob" | "touchclip"
//                posamezen del v print orientaciji → F6 → Export STL
//    "plate"     vsi deli v print orientaciji
//    "tft_test"  hiter test (~20 min): le sprednja plošča okoli TFT z oknom, pocketom in 4 bossi
//                → preveri lego lukenj in prileganje stekla, preden tiskaš cel bezel
//
//  PRINT  (PETG ali ASA, matte black, 0.4 nozzle, 0.2 mm layer, brez supportov):
//    bezel    front face down na texturiran PEI → mat površina brez obdelave
//    body     back face down (stene collarja so nagnjene le za `tilt`, ≤ 30° je OK)
//    rear     outer face down
//    knob     top up · touchclip: back face down
//    Stene 2.4 mm = 6 perimetrov (polne stene), infill 15–20 % gyroid.
//
//  BOM:
//    4× M3 heat-set insert (knurled, OD 4.0, L = insert_L) + 4× M3×7 (rear cover → body)
//    4× M3×7 + 8× M3 washer DIN 125 (TFT PCB → bosses, vijak sam nareže navoj; 2 podložki pod glavo!)
//    2× M2×6 self-tapping (touch clip)
//    1× HW-040 encoder modul (PCB ~26×18.5×1.3, EC11 D-shaft Ø6, bushing M7×0.75 ~5 mm)
//    1× ZS-042 DS3231 RTC modul (~38×22, CR2032 držalo spodaj)
//    1× AHT10 modul (~16×11) — header spajkaj na stran BREZ senzorja
//    1× TTP223 touch modul (~15×11 mm) + foam pad ~3 mm (ali 2× double-sided foam tape)
//    1× panel-mount DC jack 5.5/2.1 (npr. DC-022B)
//    1× buck modul 12V→5V (MP1584 ~22×17), 4× rubber bumper Ø10 (priporočeno)
//    VHB / foam trak za DevKit in buck
//
//  MONTAŽA:
//    1. Heat-set inserte v body bosses (spajkalnik ~230 °C, od zadaj).
//    2. TTP223 s pad-om naprej v pocket (pad na 0.8 mm steni) → foam → touch clip (2× M2).
//       Pini headerja na strani pad-a ne smejo štrleti (odreži v ravnini ali prispajkaj žice).
//    3. HW-040 od zadaj skozi bezel: telo encoderja na ploščo, PCB med vodila
//       (preprečujejo zasuk), spredaj washer + nut (ležita v counterbore pod knobom).
//    4. TFT: steklo v pocket, PCB na 4 bosses (M3×7 + 2 podložki, vijak nareže navoj, zategni rahlo).
//    5. Bezel potisni v body collar → 4 snap-fiti kliknejo (45° release = da se sneti).
//    6. DevKit v cradle (USB proti desni steni), buck v bay, DC jack od zunaj v rear.
//       ZS-042 (baterija proti coverju) in AHT10 (senzor proti rešetki) pritisni
//       v snap držala na rear coverju — kljukice kliknejo čez rob PCB.
//    7. Rear cover → 4× M3 countersunk. Knob nazadnje.
// =====================================================================

/* [Pogled] */
part = "exploded"; // [exploded, assembly, section, bezel, body, rear, knob, touchclip, plate, tft_test]
explode = 1.0;     // [0:0.05:2]
show_components = true;
show_axes = true;
section_x = 113;   // rez za "section" (privzeto skozi os encoderja)

/* [Naklon] */
tilt = 18;         // [0:1:30] naklon sprednje plošče nazaj (°)
D = 44;            // min. globina ohišja (velja pri tilt = 0)
D_top = 32;        // globina strehe za zgornjim robom zaslona pri naklonu

/* [Ohišje] */
W = 138;          // širina
H = 80;           // višina sprednje plošče (merjeno v ravnini plošče)
R = 10;           // radij vogalov (front view)
wall = 2.4;       // stena = 6× 0.4 perimetri
b = 7;            // globina vidnega bezel pasu
t_front = 3.0;    // debelina sprednje plošče
t_rear = 2.5;     // debelina rear cover
edge_r = 2.5;     // soft round sprednjega roba
seam_ch = 0.5;    // chamfer na spojih → V-groove shadow line
back_ch = 1.0;    // chamfer zunanjega roba rear cover
clr = 0.2;        // zračnost rim ↔ body
cov_clr = 0.25;   // zračnost locating lip ↔ body

/* [Snap-fit] */
rim_t = 1.6;      // debelina spigot rima / tongue
rim_d = 11;       // globina rima = dolžina tongue (strain ~1 % → OK za PETG/PLA)
snap_w = 10;
snap_slot = 0.8;
snap_h = 0.7;     // višina hook lipa
snap_flat = 0.6;
snap_ret = 45;    // retention kot: 45 = separable, 80+ = praktično trajno

/* [Rear vijaki] */
boss_in = 7.5;    // os bossa od zunanjega roba
boss_r = 4.0;
boss_len = 9;
boss_gus = 9;     // 45° gusset pred bossom
insert_od = 4.0;  // ⚠ zunanji premer knurled inserta
insert_L = 5;     // ⚠ dolžina inserta (M3×OD4 so v prodaji 3/4/5/6 mm; priporočeno 4–5)
insert_d = 3.7;   // luknja = OD − 0.3 (PETG 3.6–3.8 → natisni test)
screw_L = 7;      // dolžina M3 vijakov (pri countersunk vključno z glavo)
screw_head = "csk"; // [csk, cap] csk = DIN 7991 / ISO 10642 v ugrez, cap = DIN 912 / pan na površini
screw_d = 3.4;
csk_d = 6.6;      // countersink M3 DIN 7991

/* [TFT 2.8" ILI9341 SPI + resistive touch (MSP2807 "2.8 TFT SPI 240x320 V1.x")] */
//  Vse mere gledano OD SPREDAJ (stran stekla), pin header levo (= "spodaj" na portret risbi).
//  Vir: LCDwiki MSP2807 LCM outline (V1.2): PCB 86×50, luknje Ø3.2 na 78.08×44 (3.0 od robov),
//  TP steklo 69.2×50.0 ±0.2, AA 57.6×43.2, VA 59.45×45.2, debelina brez headerja 5.6.
//  Pozicija modula v ohišju: tft_x0. Okno v bezelu sledi steklu samodejno.
tft_pcb = [86, 50, 1.6];      // PCB: širina × višina × debelina
tft_x0 = 4.5;                 // levi rob PCB od zunanjega roba ohišja (min ~4.4 = rim)
tft_hole_pitch = [78.08, 44]; // ⚠ razmik vijakov os–os (risba V1.2) — preveri s part = "tft_test"
tft_hole_x0 = 4.92;           // ⚠ levi rob PCB (header) → os levih vijakov
tft_hole_z0 = 3.0;            // spodnji rob PCB → os spodnjih vijakov
tft_pcb_hole = 3.2;           // premer lukenj v PCB (pad Ø4.7)
tft_glass = [69.2, 50.5, 3.5];// ⚠ steklo LCD + TP (izmerjeno 69 × 50.5; risba 69.2 × 50.0 ±0.2), TP 1.2 + LCD 2.3
tft_glass_from_hole = 5.48;   // ⚠ os levega vijaka → levi rob stekla (desno ostane 3.40)
tft_glass_dz = (tft_pcb[1] - tft_glass[1]) / 2;   // steklo centrirano na PCB
tft_glass_clr = 0.2;          // zračnost okoli stekla
tft_aa = [57.6, 43.2];        // active area
tft_aa_dx = 8.7;              // levi rob stekla (FPC/header stran) → AA; desno ostane 2.9
tft_aa_dz = (tft_glass[1] - tft_aa[1]) / 2;
tft_va = [59.45, 45.2];       // viewing area ≈ občutljivo območje touch-a
tft_va_dx = 7.7;              // levi rob stekla → VA
tft_stack = 4.0;              // sprednja ploskev stekla → sprednja ploskev PCB (TP 1.2 + LCD 2.3 + tape 0.5)
touch_relief = 0.3;           // bezel ne pritiska na TP nad VA (+1 mm) → brez lažnih dotikov
tft_boss_d = 6;               // boss se ob steklu po potrebi sam zareže v D-obliko
tft_screw_hole = 2.5;         // M3 strojni vijak nareže navoj v PETG (M2.5 → 2.1)
tft_washer = 1.0;             // podložke pod glavo TFT vijaka (2× DIN 125 M3 = 1.0) → vijak ne prebije fronte
tft_skin = 1.2;               // min. sprednja koža pred konico TFT vijaka
glass_pocket = 1.0;
win_margin = 0.6;             // okno = AA + margin
win_ch = 1.5;                 // 45° chamfer okna
win_r = 0.8;

/* [HW-040 encoder + knob] */
x_enc = 113;
z_enc = 51.2;                 // poravnano: vrh knoba = vrh okna
enc_hole = 7.4;
enc_shaft_L = 14.5;           // ⚠ dolžina gredi od mounting face (vrh ohišja EC11); HW-040: 21 od dna PCB
enc_bush_L = 5;               // ⚠ dolžina navoja bushinga
enc_flat_L = 7;               // ⚠ dolžina D-flat dela gredi (od konice)
enc_body = [12.4, 6.5, 12.4]; // EC11 telo (š × višina do PCB × v)
hw_pcb = [26, 18.5, 1.3];     // ⚠ HW-040 PCB: dolžina (v smeri headerja) × širina × debelina
hw_far = 9.5;                 // ⚠ os encoderja → rob PCB nasproti headerja
hw_hdr = "left";              // [left, right, up, down] smer headerja (gledano od spredaj)
hw_hdr_back = true;           // ⚠ header na zadnji strani PCB (nasproti encoderja)
hw_pin_out = 6;               // pini kotnega headerja čez rob PCB
hw_dupont = 14;               // dupont konektor (za kontrolo prostora; 0 = spajkane žice)
hw_rail_t = 1.2;              // vodila ob PCB (anti-rotation)
hw_rail_L = 12;               // dolžina vodil (od konca nasproti headerja)
cb_d = 14;                    // counterbore za washer+nut (skrit pod knobom)
cb_depth = 1.2;
knob_d = 25;
knob_h_min = 12;
knob_gap = 1.0;
knob_flutes = 36;
halo = true;                  // fin utor okoli knoba
halo_d = 29;

/* [Back touch — TTP223] */
z_btn = 22.8;                 // poravnano s spodnjim robom okna
ttp = [15.0, 11.0];           // ⚠ PCB mini modula (večji modul: [28, 24])
ttp_t = 1.0;                  // ⚠ debelina PCB
ttp_hdr = 1;                  // stran headerja: 1 = desno (+x), -1 = levo
t_touch = 0.8;                // stena med prstom in pad-om
ttp_clr = 0.25;               // zračnost pocket ↔ PCB
touch_mark_d = 13;            // gravuran obroč = vidno območje dotika
touch_engrave = 0.4;          // globina gravure (2 layerja pri 0.2 mm)
foam_t = 3.0;                 // foam pad pred stiskom
foam_comp = 0.5;              // stisk foama (0.5 = na polovico) → pad stalno pritisnjen na steno
clip_t = 2.0;
clip_boss_h = 2.0;            // bosses za clip nad zadnjo stranjo plošče

/* [ESP32-S3 N16R8 DevKitC-1 klon] */
dk = [63.3, 25.4];            // ⚠ AliExpress/Temu N16R8 44-pin klon (2× USB-C "COM"/"USB"): 63.3×25.4;
                              //   nekateri kloni so 28 široki, original DevKitC-1 ~62.7 → IZMERI s kljunastim merilom
dk_t = 1.6;
cradle_h = 4;                 // višina PCB nad rear cover (prostor za spoje spodaj)
ez0 = 14;                     // spodnji rob DevKita
usb_slot = true;              // servisni slot za oba USB-C v desni steni

/* [12 V DC + buck] */
jx = 20;
jz = 22;
dc_hole = 11.0;               // ⚠ izmeri navoj svojega jacka (DC-022B ~11, manjši tipi ~8)
buck = true;
bk = [22.5, 17.5];            // MP1584 + zračnost
bx0 = 34;
bz0 = 12;
label = true;

/* [Snap držala za module na rear coverju] */
pcb_post_t = 1.2;             // debelina kljukice (upogib ven)
pcb_lip = 0.6;                // kljukica čez rob PCB
pcb_ledge = 1.6;              // podporni ledge pod robom PCB

/* [ZS-042 DS3231 RTC] */
zs = true;
zs_pcb = [38, 22, 1.6];       // ⚠ PCB: dolžina × višina × debelina
zs_x0 = 10;                   // levi rob PCB
zs_z0 = 44;                   // spodnji rob PCB
zs_stand = 6.0;               // ⚠ višina PCB nad coverjem (CR2032 držalo spodaj ~5 mm + zračnost)
zs_hdr = 1;                   // 6-pin header: 1 = desno (+x), -1 = levo

/* [AHT10 temp/RH] */
aht = true;
aht_pcb = [16, 11, 1.6];      // ⚠ PCB: dolžina × višina × debelina
aht_cx = 112;                 // center modula (daleč od DevKita in bucka)
aht_cz = 57;
aht_gap = 2.5;                // senzor (1.6 mm) gleda v rešetko → reža do coverja
aht_hdr = 1;                  // 4-pin header na kratki stranici: 1 = desno, -1 = levo
aht_skirt = true;             // stena okoli modula → ločen od toplega notranjega zraka
aht_slots = 4;
aht_slot_w = 1.4;

/* [Detajli] */
feet = true;
feet_d = 10.4;
feet_depth = 1.0;
vents = true;
vent_n = 9;
vent_w = 2.2;
vent_len = 16;
vent_pitch = 5;
vent_cx = 70;
vent_cz = 58;

/* [Hidden] */
$fn = $preview ? 48 : 96;
eps = 0.01;

C_BEZEL = "#19191b";
C_BODY  = "#222225";
C_REAR  = "#1d1d20";
C_KNOB  = "#2a2a2e";
C_PART  = "#2c2c30";
C_ACC   = "#ff6a13";   // accent (paint fill v dot / puščico)

// ---------------- izpeljane mere: sprednji modul (panel koordinate) ----------------
x_btn   = x_enc;
tft_z0  = (H - tft_pcb[1]) / 2;
rim_off = wall + clr;
rim_in  = wall + clr + rim_t;
y_glass = t_front - glass_pocket;          // sprednja ploskev stekla
y_pcb   = y_glass + tft_stack;             // sprednja ploskev TFT PCB
g_x0    = tft_x0 + tft_hole_x0 + tft_glass_from_hole;
g_z0    = tft_z0 + tft_glass_dz;
win     = [tft_aa[0] + 2 * win_margin, tft_aa[1] + 2 * win_margin];
wx0     = g_x0 + tft_aa_dx - win_margin;
wz0     = g_z0 + tft_aa_dz - win_margin;

y_ttp_back = t_touch + ttp_t;                         // zadnja ploskev TTP223 PCB
y_press    = y_ttp_back + foam_t * (1 - foam_comp);   // sprednja ploskev press bloka
y_clip     = t_front + clip_boss_h;                   // sprednja ploskev touch clip plošče
clip_dx    = ttp[0] / 2 + 5;                          // os M2 vijakov
clip_w     = 2 * clip_dx + 7;
clip_h     = ttp[1] + 5;
hx         = x_btn + ttp_hdr * (ttp[0] / 2 - 1.3);    // os headerja

k_tip  = enc_shaft_L - t_front - knob_gap;            // konica gredi v knob koordinatah
k_bore = k_tip + 0.6;
knob_h = max(knob_h_min, k_bore + 1.4);
k_bush = enc_bush_L - t_front - knob_gap + 0.6;

// HW-040 (lokalno: +x = smer headerja, z = čez PCB, y = panel globina)
hw_a    = hw_hdr == "right" ? 0 : hw_hdr == "up" ? -90 : hw_hdr == "down" ? 90 : 180;
hw_y0   = t_front + enc_body[1];                      // sprednja ploskev PCB (stran encoderja)
hw_y1   = hw_y0 + hw_pcb[2];                          // zadnja ploskev PCB
hw_end  = hw_pcb[0] - hw_far;                         // lokalni x roba s headerjem
hw_hy0  = hw_hdr_back ? hw_y1 : hw_y0 - 2.54;         // y razpon headerja / duponta
hw_env  = hw_end + hw_pin_out + hw_dupont;            // doseg headerja + konektorja

// ---------------- izpeljane mere: naklon in wedge body (world koordinate) ----------------
L_c    = rim_d + 1.5;                         // collar = del body, ki sledi naklonu
lift   = (b + L_c) * sin(tilt);               // dvig spodnjega roba spredaj ("chin")
Hb     = L_c * sin(tilt) + H * cos(tilt);     // višina zadnjega dela → ravna streha
y_back = max(D, H * sin(tilt) + D_top);       // zunanja ploskev rear cover
y_bb   = y_back - t_rear;                     // zadnja ploskev body = notranja ploskev cover
y_rear_in = y_bb;
y_eb   = y_rear_in - cradle_h;                // zadnja ploskev DevKit PCB
y_foot0 = (b + L_c) * cos(tilt);              // začetek ravnega dna
ex1 = W - wall - 3.0;

// vijaki: rear cover → insert, TFT PCB → boss
screw_eng   = screw_L - t_rear;                                  // del vijaka za ploskvijo body
insert_depth = max(insert_L, screw_eng) + 1.0;                   // + prostor za staljen material
tft_tip     = y_pcb - (screw_L - tft_pcb[2] - tft_washer);       // y konice TFT vijaka
tft_hole_y0 = max(tft_skin, min(2.2, tft_tip - 0.5));            // začetek slepe luknje
ex0 = ex1 - dk[0];
ez1 = ez0 + dk[1];

corners = [[boss_in, boss_in], [W - boss_in, boss_in],
           [boss_in, Hb - boss_in], [W - boss_in, Hb - boss_in]];
snaps   = [[W * 0.27, 1], [W * 0.73, 1], [W * 0.27, -1], [W * 0.73, -1]];

// snap lip profil (u = y, v = radialno ven)
yt  = b + rim_d;
lp0 = yt - 0.2;
lp1 = lp0 - snap_h / tan(30);        // 30° lead-in
lp2 = lp1 - snap_flat;
lp3 = lp2 - snap_h / tan(snap_ret);  // retention face

function tft_holes() = [for (i = [0, 1], j = [0, 1])
    [tft_x0 + tft_hole_x0 + i * tft_hole_pitch[0],
     tft_z0 + tft_hole_z0 + j * tft_hole_pitch[1]]];

// razdalja točke do pravokotnika (0 = znotraj)
function d_rect(p, x0, z0, w, h) =
    let(dx = max(x0 - p[0], 0, p[0] - (x0 + w)), dz = max(z0 - p[1], 0, p[1] - (z0 + h)))
    sqrt(dx * dx + dz * dz);

tft_hole_glass = min([for (h = tft_holes())
    d_rect(h, g_x0 - tft_glass_clr, g_z0 - tft_glass_clr,
           tft_glass[0] + 2 * tft_glass_clr, tft_glass[1] + 2 * tft_glass_clr)]);

function ex(v) = (part == "exploded") ? v * explode : 0;

// =====================================================================
//  KOORDINATE: X = širina (desno), Z = višina (gor), Y = globina (nazaj)
//  "panel" koordinate: sprednja ploskev bezela pri y = 0 (kot pri tilt = 0).
//  panel() jih nagne za `tilt` okoli spodnjega roba in dvigne za `lift`.
// =====================================================================
module panel() translate([0, 0, lift]) rotate([-tilt, 0, 0]) children();

// ---------------- helperji ----------------
module rrect(w, h, r) {
    rr = max(r, 0.05);
    translate([rr, rr]) offset(r = rr)
        square([max(w - 2 * rr, 0.01), max(h - 2 * rr, 0.01)]);
}
module rrect_in(d) translate([d, d]) rrect(W - 2 * d, H - 2 * d, R - d);    // panel obris
module rrect_hb(d) translate([d, d]) rrect(W - 2 * d, Hb - 2 * d, R - d);   // zadnji obris

// 2D profil v XZ ravnini, extrudiran od y0 do y0+h
module xz(y0, h) translate([0, y0, 0]) rotate([90, 0, 0]) translate([0, 0, -h]) linear_extrude(h) children();

// cilinder vzdolž +Y (d1 pri y0, d2 pri y0+h)
module ycyl(x, z, y0, h, d1, d2, fn = 0)
    translate([x, y0, z]) rotate([-90, 0, 0])
        cylinder(h = h, d1 = d1, d2 = d2, $fn = (fn > 0 ? fn : $fn));

module slab(y, d)    xz(y, eps) rrect_in(d);
module slab_hb(y, d) xz(y, eps) rrect_hb(d);

// panel volumen z zaobljenim / chamfer sprednjim in zadnjim robom
module shell_solid(y0, y1, fr = 0, fch = 0, bch = 0, steps = 8) {
    hull() {
        if (fr > 0)
            for (i = [0 : steps]) let(a = 90 * i / steps)
                slab(y0 + fr * (1 - cos(a)), fr * (1 - sin(a)));
        else if (fch > 0) { slab(y0, fch); slab(y0 + fch, 0); }
        else slab(y0, 0);
        if (bch > 0) { slab(y1 - bch - eps, 0); slab(y1 - eps, bch); }
        else slab(y1 - eps, 0);
    }
}

module win2d(e) translate([wx0 - e, wz0 - e]) rrect(win[0] + 2 * e, win[1] + 2 * e, win_r + e);

module snap_side(s) {
    if (s[1] > 0) children();
    else translate([0, 0, H]) mirror([0, 0, 1]) children();
}

module lip_profile()
    polygon([[lp0, -0.6], [lp0, 0], [lp1, snap_h], [lp2, snap_h], [lp3, 0], [lp3, -0.6]]);

module lip(s) snap_side(s)
    translate([s[0] - snap_w / 2, 0, H - rim_off])
        multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
            linear_extrude(snap_w) lip_profile();

module tongue_slots(s) snap_side(s)
    for (sx = [-1, 1])
        translate([s[0] + sx * (snap_w / 2 + snap_slot / 2) - snap_slot / 2, b, H - rim_in - 0.5])
            cube([snap_slot, rim_d + 1, rim_t + 1]);

module snap_pocket(s) {
    yf = lp3 + (clr + 0.15) / tan(snap_ret);   // rahel preload → bezel se pritegne
    snap_side(s)
        translate([s[0] - snap_w / 2 - 0.4, yf, H - wall - eps])
            cube([snap_w + 0.8, lp0 + 0.4 - yf, snap_h + 0.25 + eps]);
}

// HW-040 lokalni koordinatni sistem → panel (os encoderja, rotacija okoli Y)
module hw_place() translate([x_enc, 0, z_enc]) rotate([0, hw_a, 0]) children();

module hw_rails() {
    g = 0.3;                                  // zračnost PCB ↔ vodilo
    yy = hw_y1 - t_front + eps;               // do zadnje ploskve PCB
    for (sz = [-1, 1])
        translate([-hw_far - g - hw_rail_t, t_front - eps,
                   sz > 0 ? hw_pcb[1] / 2 + g : -hw_pcb[1] / 2 - g - hw_rail_t])
            cube([hw_rail_L + g + hw_rail_t, yy, hw_rail_t]);
    translate([-hw_far - g - hw_rail_t, t_front - eps, -hw_pcb[1] / 2 + 3])
        cube([hw_rail_t, yy, hw_pcb[1] - 6]);
}

// =====================================================================
//  1) FRONT BEZEL  (panel koordinate)
// =====================================================================
module bezel() {
    difference() {
        union() {
            // vidni pas + sprednja plošča
            difference() {
                shell_solid(0, b, fr = edge_r, bch = seam_ch);
                xz(t_front, b + 1) rrect_in(rim_in);
            }
            // spigot rim z lead-in chamferjem
            difference() {
                hull() {
                    xz(b - eps, rim_d - 0.6 + eps) rrect_in(rim_off);
                    xz(b + rim_d - eps, eps) rrect_in(rim_off + 0.6);
                }
                xz(b - 1, rim_d + 2) rrect_in(rim_in);
                for (s = snaps) tongue_slots(s);
            }
            for (s = snaps) lip(s);

            // TFT screw bosses
            for (h = tft_holes())
                ycyl(h[0], h[1], t_front - eps, y_pcb - t_front + eps, tft_boss_d, tft_boss_d);
            // bosses za touch clip
            for (sx = [-1, 1])
                ycyl(x_btn + sx * clip_dx, z_btn, t_front - eps, clip_boss_h + eps, 5.5, 5.5);
            // HW-040: vodila ob dolgih robovih + end stop → modul se ne zasuka
            hw_place() hw_rails();
        }

        // okno zaslona z 45° chamferjem
        hull() { xz(-eps, eps) win2d(win_ch); xz(win_ch, eps) win2d(0); }
        xz(win_ch, t_front) win2d(0);
        // pocket za steklo + prostor za LCD stack do PCB (zareže TFT bosse, če segajo do stekla)
        xz(y_glass, y_pcb - y_glass + 1)
            translate([g_x0 - tft_glass_clr, g_z0 - tft_glass_clr])
                square([tft_glass[0] + 2 * tft_glass_clr, tft_glass[1] + 2 * tft_glass_clr]);
        // touch relief: plitka vdolbina pred VA (+1 mm), da rob okna ne tišči resistive TP
        if (touch_relief > 0)
            xz(y_glass - touch_relief, touch_relief + eps)
                translate([g_x0 + tft_va_dx - 1, g_z0 + (tft_glass[1] - tft_va[1]) / 2 - 1])
                    square([tft_va[0] + 2, tft_va[1] + 2]);

        // encoder: luknja, counterbore za nut, halo utor
        ycyl(x_enc, z_enc, -1, t_front + 2, enc_hole, enc_hole);
        ycyl(x_enc, z_enc, -1, 1 + cb_depth, cb_d, cb_d);
        if (halo) difference() {
            ycyl(x_enc, z_enc, -1, 1.4, halo_d + 0.8, halo_d + 0.8);
            ycyl(x_enc, z_enc, -2, 4, halo_d - 0.8, halo_d - 0.8);
        }

        // TTP223 pocket ("utor"): spredaj ostane t_touch stene pred pad-om
        translate([x_btn - ttp[0] / 2 - ttp_clr, t_touch, z_btn - ttp[1] / 2 - ttp_clr])
            cube([ttp[0] + 2 * ttp_clr, t_front - t_touch + 1, ttp[1] + 2 * ttp_clr]);
        for (sx = [-1, 1], sz = [-1, 1])   // corner relief za oglate vogale PCB
            ycyl(x_btn + sx * (ttp[0] / 2 + ttp_clr - 0.25), z_btn + sz * (ttp[1] / 2 + ttp_clr - 0.25),
                 t_touch, t_front - t_touch + 1, 1.0, 1.0, 16);
        // pry notch za izvijač (nasproti headerja)
        translate([x_btn - ttp_hdr * (ttp[0] / 2 + ttp_clr + 0.5) - 1.0, t_touch + 0.6, z_btn - 2])
            cube([2.0, t_front - t_touch + 1, 4]);
        // spredaj: gravuran obroč + "back" ikona (pod gravuro ostane t_touch - touch_engrave)
        difference() {
            ycyl(x_btn, z_btn, -1, 1 + touch_engrave, touch_mark_d + 0.7, touch_mark_d + 0.7);
            ycyl(x_btn, z_btn, -2, 4, touch_mark_d - 0.7, touch_mark_d - 0.7);
        }
        xz(-1, 1 + touch_engrave) translate([x_btn, z_btn]) back_icon();

        // slepe luknje (sprednja koža ≥ tft_skin, globina sledi dolžini vijaka)
        for (h = tft_holes())
            ycyl(h[0], h[1], tft_hole_y0, y_pcb - tft_hole_y0 + 1, tft_screw_hole, tft_screw_hole, 24);
        for (sx = [-1, 1])
            ycyl(x_btn + sx * clip_dx, z_btn, 1.0, y_clip, 1.8, 1.8, 16);
    }
}

// =====================================================================
//  2) MAIN BODY  (wedge: nagnjen collar spredaj + navpična zadnja stran)
// =====================================================================
module boss_solid(c) {
    cx = c[0]; cz = c[1];
    sx = cx < W / 2 ? -1 : 1;
    sz = cz < Hb / 2 ? -1 : 1;
    kx = cx < W / 2 ? 0 : W - 2;
    kz = cz < Hb / 2 ? 0 : Hb - 2;
    ccx = cx < W / 2 ? R : W - R;
    ccz = cz < Hb / 2 ? R : Hb - R;
    wpx = ccx + sx * (R - wall + 0.4) / sqrt(2);   // točka v steni (vrh gusseta)
    wpz = ccz + sz * (R - wall + 0.4) / sqrt(2);
    hull() {
        xz(y_bb - boss_len, boss_len)
            hull() { translate([cx, cz]) circle(r = boss_r); translate([kx, kz]) square(2); }
        xz(y_bb - boss_len - boss_gus, eps) translate([wpx, wpz]) circle(r = 0.6, $fn = 12);
    }
}

module body_outer() hull() {
    panel() shell_solid(b, b + L_c, fch = seam_ch);
    slab_hb(y_bb - seam_ch - eps, 0);
    slab_hb(y_bb - eps, seam_ch);
}

module body_cavity() {
    panel() xz(b - 1, 2) rrect_in(wall);
    hull() {
        panel() xz(b, L_c) rrect_in(wall);
        xz(y_bb - eps, 2) rrect_hb(wall);
    }
}

module usb_cut() {
    zc = (ez0 + ez1) / 2;
    yc = y_eb - dk_t - 1.6;        // višina USB-C nad PCB
    sl = dk[1] - 1.0;
    sh = 8;
    hull() for (zz = [zc - sl / 2 + sh / 2, zc + sl / 2 - sh / 2])
        translate([W - wall - 1, yc, zz]) rotate([0, 90, 0]) cylinder(d = sh, h = wall + 2);
}

module body() {
    difference() {
        union() {
            difference() { body_outer(); body_cavity(); }
            intersection() {
                body_outer();
                union() for (c = corners) boss_solid(c);
            }
        }
        // lead-in za bezel rim + slepi snap pocketi (od zunaj nevidni)
        panel() {
            hull() { xz(b - eps, eps) rrect_in(wall - 0.6); xz(b + 0.6, eps) rrect_in(wall); }
            for (s = snaps) snap_pocket(s);
        }
        // heat-set insert luknje (od zadaj)
        for (c = corners) ycyl(c[0], c[1], y_bb - insert_depth, insert_depth + 1, insert_d, insert_d, 32);
        if (usb_slot) usb_cut();
        if (feet)
            for (fx = [18, W - 18], fy = [y_foot0 + 6, y_bb - 7])
                translate([fx, fy, -eps]) cylinder(d = feet_d, h = feet_depth + eps);
    }
}

// =====================================================================
//  3) REAR COVER  (na zadnji ploskvi body, 4× M3 countersunk v heat-set inserte)
// =====================================================================
module cradle() {
    // podporni pad-i (le na koncih, kjer ni spojev headerjev) + sredinski
    for (xa = [ex0 + 0.6, ex1 - 3.0])
        translate([xa, y_eb, ez0 + 1.0]) cube([2.4, cradle_h + eps, dk[1] - 2.0]);
    translate([(ex0 + ex1) / 2 - 5, y_eb, ez0 + dk[1] / 2 - 5]) cube([10, cradle_h + eps, 10]);
    // module-end: stebrička z lipom čez rob PCB (vstavi pod kotom, spusti USB konec)
    lip_y = y_eb - dk_t - 0.15 - 1.2;
    for (zz = [ez0 + 0.4, ez1 - 3.4]) {
        translate([ex0 - 2.2, lip_y, zz]) cube([2.0, y_rear_in - lip_y + eps, 3]);
        translate([ex0 - 0.2, lip_y, zz]) cube([1.2, 1.2, 3]);
    }
    // USB-end stopa (le do višine PCB → ne zadene USB-C)
    for (zz = [ez0 + 0.4, ez1 - 3.4])
        translate([ex1 + 0.2, y_eb - 1.0, zz]) cube([1.5, cradle_h + 1.0 + eps, 3]);
    // stranske ograje ob dolgih robovih
    for (xx = [ex0 + 4, ex1 - 10], zz = [ez0 - 2.0, ez1 + 0.2])
        translate([xx, y_eb - 1.0, zz]) cube([6, cradle_h + 1.0 + eps, 1.8]);
}

module buck_bay() {
    for (zz = [bz0 + 2, bz0 + bk[1] - 4])
        translate([bx0 + 3, y_rear_in - 1.5, zz]) cube([bk[0] - 6, 1.5 + eps, 2]);
    hb = 1.5 + 1.6 + 1.0;
    for (cx = [0, 1], cz = [0, 1]) {
        px = cx == 0 ? bx0 - 1.4 : bx0 + bk[0] + 0.2;
        pz = cz == 0 ? bz0 - 1.4 : bz0 + bk[1] + 0.2;
        translate([cx == 0 ? px : px - 3.0, y_rear_in - hb, pz]) cube([4.2, hb + eps, 1.2]);
        translate([px, y_rear_in - hb, cz == 0 ? pz : pz - 3.0]) cube([1.2, hb + eps, 4.2]);
    }
}

// --- snap držalo za PCB modul (ZS-042, AHT10) ---
//  profil v (a, h): a = ven od roba PCB, h = višina nad notranjo ploskvijo coverja
module holder_profile(t, stand) {
    hr = stand + t + 0.15;                                   // spodnja ploskev kljukice
    translate([-pcb_ledge, -eps]) square([pcb_ledge, stand + eps]);              // ledge
    translate([0.3, -eps]) square([pcb_post_t, hr + 1.3 + eps]);                 // fleks steber
    polygon([[0.3 + eps, hr], [-pcb_lip, hr], [-pcb_lip, hr + 0.3], [0.3 + eps, hr + 1.3]]);
}

// 2 + 2 kljukici na dolgih robovih; pri headerju odmaknjeni od pinov
module pcb_holder(x0, z0, pcb, stand, hdr) {
    L = pcb[0];
    for (xs = hdr > 0 ? [0.5, L - 8] : [4, L - 4.5], e = [0, 1])
        multmatrix([[0, 0, 1, x0 + xs], [0, -1, 0, y_rear_in], [e == 0 ? -1 : 1, 0, 0, z0 + e * pcb[1]], [0, 0, 0, 1]])
            linear_extrude(4) holder_profile(pcb[2], stand);
}

function aht_x0() = aht_cx - aht_pcb[0] / 2;
function aht_z0() = aht_cz - aht_pcb[1] / 2;

module aht_skirt_solid() {
    o = 0.3 + pcb_post_t + 1.0;               // prostor za upogib kljukic
    hs = aht_gap + aht_pcb[2] + 2;
    difference() {
        translate([aht_x0() - o - 1.2, y_rear_in - hs, aht_z0() - o - 1.2])
            cube([aht_pcb[0] + 2 * o + 2.4, hs + eps, aht_pcb[1] + 2 * o + 2.4]);
        translate([aht_x0() - o, y_rear_in - hs - 1, aht_z0() - o])
            cube([aht_pcb[0] + 2 * o, hs + 2, aht_pcb[1] + 2 * o]);
    }
}

module aht_grille()
    for (i = [0 : aht_slots - 1]) let(sx = aht_cx + (i - (aht_slots - 1) / 2) * 3)
        hull() for (zz = [aht_cz - 3.5 + aht_slot_w / 2, aht_cz + 3.5 - aht_slot_w / 2])
            ycyl(sx, zz, y_bb - 1, t_rear + 2, aht_slot_w, aht_slot_w, 16);

module rear() {
    difference() {
        union() {
            // plošča z V-groove chamferjem spredaj in chamferjem zunaj
            hull() {
                slab_hb(y_bb, seam_ch);
                xz(y_bb + seam_ch, t_rear - seam_ch - back_ch) rrect_hb(0);
                slab_hb(y_back - eps, back_ch);
            }
            // locating lip po ravnih stranicah (vogali so za bosse)
            difference() {
                xz(y_bb - 2.5, 2.5 + eps) rrect_hb(wall + cov_clr);
                xz(y_bb - 3, 4) rrect_hb(wall + cov_clr + 1.2);
                for (c = corners) ycyl(c[0], c[1], y_bb - 3, 4, 2 * (boss_r + 4), 2 * (boss_r + 4), 32);
            }
            cradle();
            if (buck) buck_bay();
            if (zs)  pcb_holder(zs_x0, zs_z0, zs_pcb, zs_stand, zs_hdr);
            if (aht) {
                pcb_holder(aht_x0(), aht_z0(), aht_pcb, aht_gap, aht_hdr);
                if (aht_skirt) aht_skirt_solid();
            }
        }
        if (aht) aht_grille();
        for (c = corners) {
            ycyl(c[0], c[1], y_bb - 1, t_rear + 2, screw_d, screw_d, 24);
            if (screw_head == "csk")
                ycyl(c[0], c[1], y_back - (csk_d - screw_d) / 2, (csk_d - screw_d) / 2 + eps, screw_d, csk_d, 32);
        }
        ycyl(jx, jz, y_bb - 1, t_rear + 2, dc_hole, dc_hole, 64);
        if (vents)
            for (i = [0 : vent_n - 1]) let(vx = vent_cx + (i - (vent_n - 1) / 2) * vent_pitch)
                hull() for (zz = [vent_cz - vent_len / 2 + vent_w / 2, vent_cz + vent_len / 2 - vent_w / 2])
                    ycyl(vx, zz, y_bb - 1, t_rear + 2, vent_w, vent_w, 16);
        // gravura berljiva od zadaj
        if (label)
            translate([jx, y_back - 0.5, jz + 11.5]) rotate([90, 0, 180]) linear_extrude(0.5 + eps)
                text("12V DC", size = 3.2, font = "Liberation Sans:style=Bold",
                     halign = "center", valign = "center");
    }
}

// =====================================================================
//  4) KNOB  (lokalno: os = +Z, spodaj z = 0, vrh z = knob_h)
// =====================================================================
module d_shape() intersection() { circle(d = 6.15, $fn = 40); translate([-4, -4]) square([8, 4 + 1.55]); }

module knob_local() {
    difference() {
        hull() {
            cylinder(d = knob_d - 1.0, h = eps);
            translate([0, 0, 0.5]) cylinder(d = knob_d, h = knob_h - 1.5);
            translate([0, 0, knob_h - eps]) cylinder(d = knob_d - 2.0, h = eps);
        }
        // fini fluting, zgornji pas gladek
        for (i = [0 : knob_flutes - 1]) rotate(i * 360 / knob_flutes)
            translate([knob_d / 2 + 0.15, 0, 1.2]) cylinder(r = 0.8, h = knob_h - 4.0, $fn = 16);
        // plitka konkavna skleda na vrhu
        translate([0, 0, knob_h + 60 - 0.6]) sphere(r = 60, $fn = 96);
        // indikator
        translate([0, knob_d / 2 - 3.0, knob_h - 0.7]) cylinder(d = 1.8, h = 1, $fn = 24);
        // spodaj: nut recess → bushing → okrogel bore → D-bore (prehodi 45°, brez supportov)
        translate([0, 0, -eps]) cylinder(d = 13, h = 1.2 + eps);
        translate([0, 0, 1.2]) cylinder(d1 = 13, d2 = 7.8, h = 2.6);
        translate([0, 0, -eps]) cylinder(d = 7.8, h = k_bush + eps);
        translate([0, 0, k_bush]) cylinder(d1 = 7.8, d2 = 6.1, h = 0.85);
        translate([0, 0, -eps]) cylinder(d = 6.15, h = k_bore + eps, $fn = 40);
        translate([0, 0, k_tip - enc_flat_L + 0.5]) linear_extrude(k_bore - (k_tip - enc_flat_L + 0.5) + eps) d_shape();
    }
}

module knob_placed() {
    translate([x_enc, -knob_gap, z_enc]) rotate([90, 0, 0]) {
        color(C_KNOB) knob_local();
        if (show_components)
            color(C_ACC) translate([0, knob_d / 2 - 3.0, knob_h - 0.65]) cylinder(d = 1.7, h = 0.6, $fn = 24);
    }
}

// =====================================================================
//  5) TOUCH CLIP  (pritrdi TTP223: press blok stisne foam → pad brez zračne reže)
// =====================================================================
module back_icon()
    for (p = [[[1.6, 2.8], [-1.4, 0]], [[-1.4, 0], [1.6, -2.8]]])
        hull() for (q = p) translate(q) circle(d = 1.1, $fn = 16);

module touch_accent()   // paint fill ikone (samo vizualno)
    color(C_ACC) xz(0.02, touch_engrave - 0.05) translate([x_btn, z_btn]) offset(delta = -0.05) back_icon();

module touchclip() {
    difference() {
        union() {
            hull() for (sx = [-1, 1], sz = [-1, 1])
                translate([x_btn + sx * (clip_w / 2 - 2), y_clip, z_btn + sz * (clip_h / 2 - 2)])
                    rotate([-90, 0, 0]) cylinder(r = 2, h = clip_t, $fn = 24);
            translate([x_btn - (ttp[0] - 1.5) / 2, y_press, z_btn - (ttp[1] - 1.5) / 2])
                cube([ttp[0] - 1.5, y_clip - y_press + eps, ttp[1] - 1.5]);
        }
        // slot za header / žice
        translate([hx - 2, y_press - 1, z_btn - 5]) cube([4, y_clip + clip_t - y_press + 2, 10]);
        for (sx = [-1, 1])
            ycyl(x_btn + sx * clip_dx, z_btn, y_clip - 1, clip_t + 2, 2.3, 2.3, 16);
    }
}

// =====================================================================
//  GHOST KOMPONENTE (samo za vizualizacijo)
// =====================================================================
// --- sprednji modul (panel koordinate) ---
module tft() {
    color("#a8161b") difference() {
        translate([tft_x0, y_pcb, tft_z0]) cube([tft_pcb[0], tft_pcb[2], tft_pcb[1]]);
        for (h = tft_holes()) ycyl(h[0], h[1], y_pcb - 1, tft_pcb[2] + 2, tft_pcb_hole, tft_pcb_hole, 24);
    }
    color("#0b0b0d") translate([g_x0, y_glass, g_z0]) cube([tft_glass[0], tft_glass[2], tft_glass[1]]);
    color("#14294d") translate([g_x0 + tft_aa_dx, y_glass - 0.03, g_z0 + tft_aa_dz]) cube([tft_aa[0], 0.05, tft_aa[1]]);
    color("#c98a1a") translate([g_x0 + tft_glass[0] - 2, y_glass + tft_glass[2], g_z0 + 12])
        cube([2, y_pcb - y_glass - tft_glass[2], 26]);
    color("#111") translate([tft_x0 + 0.73, y_pcb + tft_pcb[2], tft_z0 + 25 - 17.78]) cube([2.54, 2.5, 35.56]);
    color("#d4af37") for (i = [0 : 13])
        translate([tft_x0 + 1.68, y_pcb + tft_pcb[2], tft_z0 + 25 - 16.51 + i * 2.54 - 0.32]) cube([0.64, 8.5, 0.64]);
    color("#b9bcc2") translate([tft_x0 + 56, y_pcb + tft_pcb[2], tft_z0 + 10]) cube([28, 2.6, 30]);
}

module encoder() {
    // EC11 na HW-040: bushing + gred spredaj, telo za ploščo
    color("#c4c6ca") ycyl(x_enc, z_enc, t_front - enc_bush_L, enc_bush_L, 7, 7);
    color("#d9dadd") difference() {
        ycyl(x_enc, z_enc, t_front - enc_shaft_L, enc_shaft_L - enc_bush_L, 6, 6);
        translate([x_enc - 4, t_front - enc_shaft_L - 1, z_enc + 1.5]) cube([8, enc_flat_L + 1, 4]);
    }
    hw_place() {
        color("#8d9096") translate([-enc_body[0] / 2, t_front, -enc_body[2] / 2]) cube(enc_body);
        color("#1d4f9c") translate([-hw_far, hw_y0, -hw_pcb[1] / 2]) cube([hw_pcb[0], hw_pcb[2], hw_pcb[1]]);
        color("#151515") for (zz = [-5, 0, 5])   // 10k pull-up upori
            translate([hw_end - 6.5, hw_y0 - 0.5, zz - 0.8]) cube([2, 0.5, 1.6]);
        // kotni 5-pin header (+ dupont ovojnica za kontrolo prostora)
        color("#111") translate([hw_end - 2.54, hw_hy0, -6.35]) cube([2.54, 2.54, 12.7]);
        color("#d4af37") for (i = [-2 : 2])
            translate([hw_end - 1.6, hw_hy0 + 0.95, i * 2.54 - 0.32]) cube([1.6 + hw_pin_out, 0.64, 0.64]);
        if (hw_dupont > 0)
            color("#2b2b2f", 0.6) translate([hw_end + 0.6, hw_hy0, -6.4]) cube([hw_dupont, 2.54, 12.8]);
    }
}

module enc_nut() color("#b8babe") {
    ycyl(x_enc, z_enc, cb_depth - 0.5, 0.5, 11.5, 11.5);
    ycyl(x_enc, z_enc, cb_depth - 2.5, 2.0, 10.4, 10.4, 6);
}

module ttp223() {
    x0 = x_btn - ttp[0] / 2;
    z0 = z_btn - ttp[1] / 2;
    color("#b3161d") translate([x0, t_touch, z0]) cube([ttp[0], ttp_t, ttp[1]]);
    color("#c9a227") ycyl(x_btn - ttp_hdr * 1.2, z_btn, t_touch, 0.05, min(ttp) - 2, min(ttp) - 2);   // pad (spredaj)
    color("#151515") translate([x_btn - 2.5, y_ttp_back, z_btn - 1.5]) cube([3, 1.0, 1.6]);   // TTP223 (SOT-23-6)
    color("#f2f2f2") translate([x_btn - ttp_hdr * 5 - 0.8, y_ttp_back, z_btn + 2.5]) cube([1.6, 0.6, 0.8]);
    color("#111") translate([hx - 1.27, y_ttp_back, z_btn - 3.81]) cube([2.54, 2.5, 7.62]);
    color("#d4af37") for (i = [-1 : 1])
        translate([hx - 0.32, y_ttp_back, z_btn + i * 2.54 - 0.32]) cube([0.64, 8.5, 0.64]);
}

module foam() color("#3c3c42") difference() {
    translate([x_btn - (ttp[0] - 1.5) / 2, y_ttp_back, z_btn - (ttp[1] - 1.5) / 2])
        cube([ttp[0] - 1.5, y_press - y_ttp_back, ttp[1] - 1.5]);
    translate([hx - 2, y_ttp_back - 1, z_btn - 5]) cube([4, y_press - y_ttp_back + 2, 10]);
}

// --- zadnji del (world koordinate) ---
module devkit() {
    yt0 = y_eb - dk_t;
    color("#1c1c1e") translate([ex0, yt0, ez0]) cube([dk[0], dk_t, dk[1]]);
    color("#262a33") translate([ex0, yt0 - 0.8, ez0 + (dk[1] - 18) / 2]) cube([25.5, 0.8, 18]);
    color("#c9cbd0") translate([ex0 + 7.0, yt0 - 0.8 - 2.4, ez0 + (dk[1] - 16) / 2]) cube([17.6, 2.4, 16]);
    for (zr = [ez0 + 1.27, ez1 - 1.27]) {
        color("#111") translate([ex0 + 3.43, yt0 - 2.5, zr - 1.27]) cube([55.88, 2.5, 2.54]);
        color("#d4af37") for (i = [0 : 21])
            translate([ex0 + 3.43 + 1.27 + i * 2.54 - 0.32, yt0 - 8.5, zr - 0.32]) cube([0.64, 6, 0.64]);
    }
    color("#c4c6ca") for (zc = [ez0 + dk[1] / 2 - 5.5, ez0 + dk[1] / 2 + 5.5])
        translate([ex1 - 7.3, yt0 - 3.2, zc - 4.47]) cube([7.8, 3.2, 8.94]);
}

module buck_mod() {
    yp = y_rear_in - 1.5 - 1.6;
    color("#1d4f9c") translate([bx0, yp, bz0]) cube([bk[0] - 0.5, 1.6, bk[1] - 0.5]);
    color("#2a2a2a") translate([bx0 + 3, yp - 4.0, bz0 + 4.5]) cube([7.5, 4.0, 7.5]);
    color("#151515") translate([bx0 + 13, yp - 1.0, bz0 + 6]) cube([3, 1.0, 5]);
    color("#c9a227") for (cx = [1.5, bk[0] - 3.5], cz = [1.5, bk[1] - 3.5])
        translate([bx0 + cx, yp - 0.05, bz0 + cz]) cube([1.5, 0.05, 1.5]);
}

module zs042() {
    yp = y_rear_in - zs_stand;                 // zadnja ploskev PCB (stran baterije)
    x1 = zs_x0 + zs_pcb[0];
    color("#1d4f9c") translate([zs_x0, yp - zs_pcb[2], zs_z0]) cube([zs_pcb[0], zs_pcb[2], zs_pcb[1]]);
    color("#2a2a2c") ycyl(zs_x0 + zs_pcb[0] / 2 - 2, zs_z0 + zs_pcb[1] / 2, yp, zs_stand - 0.6, 21, 21);   // CR2032 držalo
    color("#151515") translate([zs_x0 + 14, yp - zs_pcb[2] - 2.3, zs_z0 + 7]) cube([10.3, 2.3, 7.5]);   // DS3231 SO-16
    color("#151515") translate([zs_x0 + 5, yp - zs_pcb[2] - 1.5, zs_z0 + 8]) cube([5, 1.5, 4]);         // AT24C32
    // 6-pin kotni header (32K SQW SCL SDA VCC GND) + 4-pin pass-through na drugem koncu
    hx = zs_hdr > 0 ? x1 - 2.54 : zs_x0;
    color("#111") translate([hx, yp - zs_pcb[2] - 2.54, zs_z0 + zs_pcb[1] / 2 - 7.62]) cube([2.54, 2.54, 15.24]);
    color("#d4af37") for (i = [0 : 5])
        translate([zs_hdr > 0 ? x1 - 1.6 : zs_x0 - 6, yp - zs_pcb[2] - 1.6,
                   zs_z0 + zs_pcb[1] / 2 - 6.35 + i * 2.54 - 0.32]) cube([7.6, 0.64, 0.64]);
    color("#111") translate([zs_hdr > 0 ? zs_x0 : x1 - 2.54, yp - zs_pcb[2] - 2.54, zs_z0 + zs_pcb[1] / 2 - 5.08])
        cube([2.54, 2.54, 10.16]);
}

module aht10() {
    yp = y_rear_in - aht_gap;                  // ploskev s senzorjem (proti rešetki)
    x0 = aht_x0(); z0 = aht_z0();
    color("#1d4f9c") translate([x0, yp - aht_pcb[2], z0]) cube([aht_pcb[0], aht_pcb[2], aht_pcb[1]]);
    color("#e8e8e8") translate([aht_cx - 2.5, yp, aht_cz - 2]) cube([5, 1.6, 4]);   // AHT10 4×5×1.6
    // ravni 4-pin header na kratki stranici, pini proti notranjosti
    hx = aht_hdr > 0 ? x0 + aht_pcb[0] - 2.54 : x0;
    color("#111") translate([hx, yp - aht_pcb[2] - 2.54, aht_cz - 5.08]) cube([2.54, 2.54, 10.16]);
    color("#d4af37") for (i = [0 : 3])
        translate([hx + 0.95, yp - aht_pcb[2] - 8.5, aht_cz - 3.81 + i * 2.54 - 0.32]) cube([0.64, 8.5 + aht_pcb[2] + 1, 0.64]);
}

module dcjack() {
    color("#2a2a2c") ycyl(jx, jz, y_back, 2.2, 13, 12.2);
    color("#050505") ycyl(jx, jz, y_back + 2.2, 0.06, 6.4, 6.4);
    color("#d9dadd") ycyl(jx, jz, y_back + 1.5, 0.8, 2.0, 2.0, 16);
    color("#9c9ea3") ycyl(jx, jz, y_back - 9, 9, dc_hole - 0.3, dc_hole - 0.3);
    color("#b8babe") ycyl(jx, jz, y_rear_in - 2.2, 2.2, 14.5, 14.5, 6);
    color("#2a2a2c") ycyl(jx, jz, y_back - 22, 13, 9, 9);
    color("#c8a24a") for (a = [90, 210, 330])
        translate([jx + 3 * cos(a) - 1, y_back - 27, jz + 3 * sin(a) - 0.2]) cube([2, 5, 0.4]);
}

module screws() color("#8e9095") for (c = corners) {
    if (screw_head == "csk") ycyl(c[0], c[1], y_back - 1.6, 1.6, 3.0, 6.0, 24);
    else                     ycyl(c[0], c[1], y_back, 3.0, 5.5, 5.5, 24);
    ycyl(c[0], c[1], y_back - screw_L, screw_L, 2.9, 2.9, 16);
}

module inserts() color("#c9a227") for (c = corners) difference() {
    ycyl(c[0], c[1], y_bb - insert_L, insert_L, insert_od, insert_od, 24);
    ycyl(c[0], c[1], y_bb - insert_L - 1, insert_L + 2, 2.6, 2.6, 16);
}

// --- osi montaže v exploded pogledu ---
module panel_axes() color("#77777d") {
    a = 0.35;
    ycyl(x_enc, z_enc, ex(-125) - knob_gap - knob_h - 6, -ex(-125) + knob_h + 20, a, a, 8);
    ycyl(x_btn, z_btn, ex(-62) - 4, -ex(-62) + ex(-20) + y_clip + 8, a, a, 8);
}
module rear_axes() color("#77777d") {
    a = 0.35;
    for (c = corners) ycyl(c[0], c[1], y_bb - 10, ex(90) + 22, a, a, 8);
    ycyl(jx, jz, y_back - 26, ex(72) + 32, a, a, 8);
}

// =====================================================================
//  SCENA
// =====================================================================
module at(v) translate([0, ex(v), 0]) children();   // v panel() → explode vzdolž nagnjene osi

module cut() {
    if (part == "section")
        intersection() { children(); translate([-100, -500, -500]) cube([section_x + 100, 1000, 1000]); }
    else children();
}

axes_on = show_axes && part == "exploded" && explode > 0;

module scene() {
    // sprednji modul — vse v panel koordinatah, nagnjeno za `tilt`
    panel() {
        at(-62)  color(C_BEZEL) cut() bezel();
        at(-125) cut() knob_placed();
        at(-20)  color(C_PART)  cut() touchclip();
        if (show_components) {
            at(-62) cut() touch_accent();
            at(-26) cut() tft();
            at(-22) cut() encoder();
            at(-95) cut() enc_nut();
            at(-42) cut() ttp223();
            at(-31) cut() foam();
        }
        if (axes_on) panel_axes();
    }
    // body + zadnji del
    color(C_BODY) cut() body();
    at(50) color(C_REAR) cut() rear();
    if (show_components) {
        at(28)  cut() devkit();
        if (buck) at(28) cut() buck_mod();
        if (zs)   at(28) cut() zs042();
        if (aht)  at(28) cut() aht10();
        at(72)  cut() dcjack();
        at(90)  cut() screws();
        at(14)  cut() inserts();
    }
    if (axes_on) rear_axes();
}

// ---------------- print orientacije ----------------
module print_bezel()   color(C_BEZEL) translate([0, H, 0]) rotate([90, 0, 0]) bezel();
module print_body()    color(C_BODY)  translate([0, 0, y_bb]) rotate([-90, 0, 0]) body();
module print_rear()    color(C_REAR)  translate([0, 0, y_back]) rotate([-90, 0, 0]) rear();
module print_clip()    color(C_PART)  translate([-x_btn, -z_btn, y_clip + clip_t]) rotate([-90, 0, 0]) touchclip();

module print_tft_test() color(C_BEZEL) translate([0, H, 0]) rotate([90, 0, 0])
    intersection() {
        bezel();
        x0 = max(tft_x0 - 3, rim_in);
        translate([x0, -1, tft_z0 - 3]) cube([tft_x0 + tft_pcb[0] + 3 - x0, y_pcb + 1, tft_pcb[1] + 6]);
    }

module plate() {
    print_bezel();
    translate([W + 10, 0, 0]) print_body();
    translate([0, H + 10, 0]) print_rear();
    translate([W + 30, H + 30, 0]) color(C_KNOB) knob_local();
    translate([W + 75, H + 30, 0]) print_clip();
}

if (part == "exploded" || part == "assembly" || part == "section") scene();
else if (part == "bezel")   print_bezel();
else if (part == "body")    print_body();
else if (part == "rear")    print_rear();
else if (part == "knob")    color(C_KNOB) knob_local();
else if (part == "touchclip") print_clip();
else if (part == "plate")   plate();
else if (part == "tft_test") print_tft_test();

// ---------------- info v konzoli ----------------
gap_L = tft_glass_from_hole;
gap_R = tft_hole_pitch[0] - tft_glass_from_hole - tft_glass[0];
echo(str("TFT: vijaki ", tft_hole_pitch[0], " × ", tft_hole_pitch[1],
         " | os vijaka → rob stekla: levo ", gap_L, ", desno ", round(gap_R * 100) / 100,
         " | PCB rob → os vijaka: levo ", tft_hole_x0, ", desno ",
         round((tft_pcb[0] - tft_hole_x0 - tft_hole_pitch[0]) * 100) / 100));
if (tft_hole_x0 < tft_pcb_hole / 2 || tft_hole_x0 + tft_hole_pitch[0] > tft_pcb[0] - tft_pcb_hole / 2 ||
    tft_hole_z0 < tft_pcb_hole / 2 || tft_hole_z0 + tft_hole_pitch[1] > tft_pcb[1] - tft_pcb_hole / 2)
    echo("⚠ TFT: luknje ležijo izven PCB → preveri tft_pcb / tft_hole_*");
if (tft_hole_glass < tft_screw_hole / 2 + 0.3)
    echo("⚠ TFT: luknja za vijak sega v steklo → preveri tft_hole_* / tft_glass_from_hole");
else if (tft_hole_glass < tft_boss_d / 2)
    echo(str("TFT: bossi so ob steklu zarezani (D-oblika, stena ob luknji ",
             round((tft_hole_glass - tft_screw_hole / 2) * 100) / 100, " mm) — OK"));

echo(str("tilt ", tilt, "° | footprint ", W, " × ", round(y_back * 10) / 10,
         " mm | višina ", round((lift + H * cos(tilt)) * 10) / 10,
         " | chin ", round(lift * 10) / 10, " | streha z = ", round(Hb * 10) / 10,
         " | knob Ø", knob_d, " × ", knob_h));

// HW-040: header + dupont ovojnica (panel x/z) → kontrola trkov
function hw_rot(p) = [x_enc + p[0] * cos(hw_a) + p[1] * sin(hw_a), z_enc - p[0] * sin(hw_a) + p[1] * cos(hw_a)];
hw_box_pts = [for (px = [hw_end - 2.54, hw_env], pz = [-6.4, 6.4]) hw_rot([px, pz])];
hw_box = [min([for (q = hw_box_pts) q[0]]), min([for (q = hw_box_pts) q[1]]),
          max([for (q = hw_box_pts) q[0]]), max([for (q = hw_box_pts) q[1]])];
function ov(b, x0, z0, x1, z1) = b[0] < x1 && b[2] > x0 && b[1] < z1 && b[3] > z0;
if (hw_box[0] < rim_in || hw_box[2] > W - rim_in || hw_box[1] < rim_in || hw_box[3] > H - rim_in)
    echo("⚠ HW-040: header/dupont sega v rim ohišja → hw_dupont = 0 (spajkane žice) ali drug hw_hdr");
if (ov(hw_box, tft_x0, tft_z0, tft_x0 + tft_pcb[0], tft_z0 + tft_pcb[1]) && hw_hy0 < y_pcb + tft_pcb[2] + 2.6)
    echo("⚠ HW-040: header/dupont trči v hrbet TFT (SD slot) → hw_hdr_back = true ali spajkane žice");
if (ov(hw_box, x_btn - clip_w / 2, z_btn - clip_h / 2, x_btn + clip_w / 2, z_btn + clip_h / 2))
    echo("⚠ HW-040: header/dupont trči v touch clip / TTP223");
echo(str("HW-040: header ", hw_hdr, " | ovojnica x ", round(hw_box[0] * 10) / 10, "…", round(hw_box[2] * 10) / 10,
         ", z ", round(hw_box[1] * 10) / 10, "…", round(hw_box[3] * 10) / 10,
         " | y ", hw_hy0, "…", hw_hy0 + 2.54, " (TFT hrbet do ", y_pcb + tft_pcb[2] + 2.6, ")"));

// ---------------- vijaki / inserti ----------------
ins_wall = boss_r - insert_d / 2;
echo(str("Rear vijaki M3×", screw_L, " (", screw_head, "): v body ", screw_eng, " mm | insert Ø", insert_od, "×", insert_L,
         " v luknji Ø", insert_d, " globine ", insert_depth, " | boss Ø", 2 * boss_r, " × ", boss_len,
         " (stena ", ins_wall, ", dno ", boss_len - insert_depth, ")"));
if (screw_eng < 3.5) echo("⚠ Rear: premalo navoja v insertu (< 3.5 mm) → daljši vijaki");
if (screw_eng < insert_L - 1) echo("⚠ Rear: vijak ne seže skozi večji del inserta → krajši insert ali daljši vijak");
if (insert_depth > boss_len - 1.0) echo("⚠ Rear: luknja za insert pregloboka za boss → povečaj boss_len");
if (ins_wall < insert_od / 2 * 0.9) echo("⚠ Rear: stena bossa okoli inserta pretanka → povečaj boss_r");
echo(str("TFT vijaki M3×", screw_L, " + podložke ", tft_washer, " mm: v bossu ", round((y_pcb - tft_tip) * 100) / 100,
         " mm, konica ", round(tft_tip * 100) / 100, " mm od fronte (min ", tft_skin, ")"));
if (tft_tip < tft_skin + 0.2) echo("⚠ TFT: vijak predolg → prebije/izboči sprednjo ploskev; dodaj podložke ali krajši vijak");
if (y_pcb - tft_tip < 3) echo("⚠ TFT: vijak prekratek (< 3 mm v bossu)");
