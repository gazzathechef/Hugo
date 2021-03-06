/* H-BarClampCross [bcc]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <metric.scad>
use <teardrop.scad>

bcc_mode = "-";
//bcc_mode = "print"; $fn=24*4;  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//bcc_mode = "printSet";  $fn=24*4;
//bcc_mode = "inspect";
//$fn=48;

module barclampCross(a=15) {
	genWallThickness = 3.3;
	outer_radius=m8_diameter/2+genWallThickness;
	clamp_width = outer_radius*2;
	clamp_length=25;
	clamp_height=3*outer_radius;
	axe_dist = 5;
	slot_width=5;
 
 	steps = 15;

 	translate([0, 0, clamp_height/2]) 
 	
 	intersection() {
 		translate([clamp_length/4, 0, 0]) 
 			sphere(r=clamp_length*7/10);

 		intersection() {
	 		union() {
	 			for (i=[0:steps]) {
	 				translate([i*(clamp_length-outer_radius)/steps, 0, 0])
	 					cylinder(h=clamp_height,r=outer_radius+i*0.3,center=true);
	 			}
	 			
	 		}

	 		difference() {
		 		union(){
		 			for (i=[0:steps]) {
						translate([i*(clamp_length-outer_radius)/steps, 0, 0]) rotate(a=-i*a/steps,v=[1,0,0]) 
							cylinder(h=clamp_height*10,r=outer_radius,center=true);
					}
		 			
		 		}
		 		union() {
			 		for (i=[0:steps]) {
						translate([i*clamp_length/steps, 0, 0]) rotate(a=-i*a/steps,v=[1,0,0]) 
							cylinder(r=slot_width/2, h=clamp_height*2, center=true);
					}


					cylinder(h=clamp_height*2,r=m8_diameter/2,$fn=18,center=true);

					translate([axe_dist+m8_diameter,0,0]) 
					rotate([90-a,0,0]) 
						cylinder(h=(clamp_width/cos(a))*2,r=m8_diameter/2,$fn=20,center=true);
			 	}
		 	}
	 	}
 	}
 	
 	
 	
 	
}
//barclampCross(a=15);

if (bcc_mode == "print") {
	barclampCross(a=90-75);	
}

module H_barClampCross_printSet() {
	for (x=[-25,8]) 
	for (y=[-9,10]) 
	translate([x, y, 0]) 
	barclampCross(a=90-75);	
}
if (bcc_mode ==  "printSet") {
	H_barClampCross_printSet();
}