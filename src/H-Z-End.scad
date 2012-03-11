/* H-Z-end [Ze]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
Ze_mode = "-";
//Ze_mode = "printSet1";  $fn=24*4;    // can be print or inspect [overlays the Ze_model with the original Ze_model] (uncomment next line)
//Ze_mode = "printSet2";  $fn=24*4;
//e_mode = "print Left";  $fn=24*4;
//Ze_mode = "print right";  $fn=24*4;
//Ze_mode = "inspect";
//Ze_mode = "assembly";

Ze_thinWallThickness         = 1;
Ze_genWallThickness          = 3;
Ze_strongWallThickness       = 9;

Ze_horizontalSuportThickness = 0.3;
Ze_verticalSupportThickness  = 0.5;

/*------------------------------------rod-------------------------------------*/
Ze_smoothRod_diam      = 8.0;
Ze_roughRod_diam       = 8.5;

/*------------------------------------zEnd------------------------------------*/
Ze_zEnd_rodsDist       = 28.315;
Ze_zEnd_heigt          = 35;
Ze_zEnd_nuttrap_offset = 12;

/*------------------------------------bearing---------------------------------*/
Ze_bear_diam           = 22.6;
Ze_bear_heigth         = 7;


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_Ze_zDir                      = Ze_zEnd_heigt;
_Ze_xDir                      = _Ze_zDir-(Ze_genWallThickness+Ze_smoothRod_diam/2);

_Ze_support_radius            = (Ze_smoothRod_diam/2+Ze_genWallThickness)*0.6;
_Ze_support_coutout_r         = circel_radius3Points([Ze_thinWallThickness,0],[_Ze_support_radius+Ze_thinWallThickness,_Ze_xDir],[_Ze_support_radius+Ze_thinWallThickness,-_Ze_xDir]);

_Ze_crosBr_bearing_dist       = Ze_bear_diam/2+Ze_strongWallThickness+ m8_nut_diameter/2;
_Ze_crosBr_bearing_noseLength = _Ze_crosBr_bearing_dist + m8_nut_diameter/2+Ze_genWallThickness- Ze_strongWallThickness;

module H_Z_end(hasCrossBrace = true) {
	_bearSuppCoutout_scale           = (Ze_zEnd_rodsDist+Ze_bear_diam/2+Ze_genWallThickness- Ze_smoothRod_diam/2 - Ze_genWallThickness/2)/(_Ze_zDir- Ze_bear_heigth -Ze_genWallThickness);
	_bearSuppCoutout_crosBrace_scale = (Ze_zEnd_rodsDist+Ze_bear_diam/2+Ze_genWallThickness- Ze_smoothRod_diam/2 - Ze_genWallThickness/2+_Ze_crosBr_bearing_noseLength)/(_Ze_zDir- m8_nut_diameter);
	
	difference() {
		union(){
			cylinder(r=Ze_smoothRod_diam/2 + Ze_genWallThickness, h=_Ze_zDir, center=false);

			// bearing holder
			translate([-Ze_zEnd_rodsDist, 0, 0]) 
			cylinder(r=Ze_bear_diam/2 +Ze_genWallThickness, h=Ze_bear_heigth+Ze_genWallThickness, center=false);

			//connector
			translate([-Ze_zEnd_rodsDist, 0, 0]) 
			linear_extrude(height=_Ze_zDir)
				barbell (r1=Ze_bear_diam/2+Ze_genWallThickness,r2=Ze_smoothRod_diam/2+Ze_genWallThickness,r3=Ze_zEnd_rodsDist/3,r4=Ze_zEnd_rodsDist/3,separation=Ze_zEnd_rodsDist); 

			// x dir rod
			translate([0, 0, Ze_roughRod_diam/2+Ze_genWallThickness]) 
			rotate(a=180,v=X) 
				teardrop (r=Ze_roughRod_diam/2+Ze_genWallThickness,h=_Ze_xDir,top_and_bottom=false);

			// x dir support
			translate([0, 0, Ze_roughRod_diam/2+Ze_genWallThickness]) 
			intersection() {
				difference() {
					rotate(a=90,v=X) 
						cylinder(r=_Ze_xDir, h=_Ze_support_radius*2, center=true);
					for (i=[1,-1]) 
					translate([0, i*(-_Ze_support_coutout_r- Ze_thinWallThickness), 0]) 
						sphere(r=_Ze_support_coutout_r,$fn=150); 
				}
				translate([0, -(Ze_roughRod_diam+2*Ze_genWallThickness)/2, 0]) 
					cube(size=[_Ze_xDir, Ze_roughRod_diam+2*Ze_genWallThickness, _Ze_xDir], center=false);
			}
			
			if (hasCrossBrace) {
				//connector
				translate([-Ze_zEnd_rodsDist, 0, 0]) 
				rotate(a=180,v=Z) 
				linear_extrude(height=_Ze_zDir)
					barbell (r1=Ze_bear_diam/2+Ze_genWallThickness,r2=Ze_strongWallThickness,r3=_Ze_crosBr_bearing_noseLength*.8,r4=_Ze_crosBr_bearing_noseLength*0.8,separation=_Ze_crosBr_bearing_noseLength); 

				//screw holde
				translate([-Ze_zEnd_rodsDist- _Ze_crosBr_bearing_dist, 0, m8_nut_diameter/2])
				rotate(a=90,v=X) 
					cylinder(r=m8_nut_diameter/2, h=Ze_strongWallThickness*2, center=true); 
			}

		}
		union(){
			translate([0, 0, Ze_genWallThickness]) 
				cylinder(r=Ze_smoothRod_diam/2, h=_Ze_zDir+2*OS, center=false);
			// bearing holder
			translate([-Ze_zEnd_rodsDist, 0, -OS]) {
				if (hasCrossBrace) {					
					cylinder(r=Ze_bear_diam/2, h=m8_nut_diameter, center=false);
					// rod coutput
					translate([0, 0, m8_nut_diameter+Ze_horizontalSuportThickness])
						cylinder(r=Ze_roughRod_diam/2, h=_Ze_zDir, center=false); 
				} else {
					cylinder(r=Ze_bear_diam/2, h=Ze_bear_heigth+OS, center=false);
					// rod coutput
					translate([0, 0, Ze_bear_heigth+Ze_horizontalSuportThickness])
						cylinder(r=Ze_roughRod_diam/2, h=_Ze_zDir, center=false); 
				}
			}

			//barebel holder support coutout
			if (hasCrossBrace) {
				translate([-(Ze_zEnd_rodsDist+Ze_bear_diam/2+Ze_genWallThickness+_Ze_crosBr_bearing_noseLength), 0, _Ze_zDir])
				scale([_bearSuppCoutout_crosBrace_scale, 1, 1]) 
				rotate(a=90,v=X) 
					cylinder(r=_Ze_zDir- m8_nut_diameter  , h=Ze_bear_diam+2*Ze_genWallThickness+2*OS, center=true); 
			} else {
				translate([-(Ze_zEnd_rodsDist+Ze_bear_diam/2+Ze_genWallThickness), 0, _Ze_zDir])
				scale([_bearSuppCoutout_scale, 1, 1]) 
				rotate(a=90,v=X) 
					cylinder(r=_Ze_zDir- Ze_bear_heigth -Ze_genWallThickness, h=Ze_bear_diam+2*Ze_genWallThickness+2*OS, center=true); 
			}

			// x dir rod
			difference() {
				translate([0, OS, Ze_roughRod_diam/2+Ze_genWallThickness]) 
				teardrop (r=Ze_roughRod_diam/2,h=_Ze_xDir+2*OS,top_and_bottom=false);

				cylinder(r=Ze_smoothRod_diam/2 + Ze_genWallThickness, h=_Ze_zDir, center=false);
			}
			

			//nuttrap
			translate([_Ze_xDir-Ze_zEnd_nuttrap_offset, 0, Ze_roughRod_diam/2+Ze_genWallThickness]) {
				rotate(a=90,v=Y) 
				rotate(a=30,v=Z) 
					cylinder(r=max(m8_nut_diameter/2 +1,Ze_roughRod_diam/2+Ze_genWallThickness)+OS, h=m8_nut_heigth, center=true);
			}

			if (hasCrossBrace) {
				//screw holde
				translate([-Ze_zEnd_rodsDist- _Ze_crosBr_bearing_dist, -Ze_strongWallThickness, m8_nut_diameter/2])
				rotate(a=90,v=Z)
				rotate(a=180,v=X) 
					teardrop (r=Ze_roughRod_diam/2,h=Ze_strongWallThickness*2+2*OS,top_and_bottom=false); 
					//cylinder(r=Ze_roughRod_diam/2, h=Ze_strongWallThickness*2+2*OS, center=true); 
			}
		}	
	}
}




if (Ze_mode == "inspect") {
	H_Z_end();
}
module H_Z_end_print() {
	H_Z_end();
}
module H_Z_end_printSet1() {
	translate([10, 12, 0]) 
	H_Z_end(hasCrossBrace = true);
	translate([-10, -12, 0]) 
	rotate(a=180,v=[0,0,1]) 
	H_Z_end(hasCrossBrace = false);
}
if (Ze_mode == "printSet1") {
	H_Z_end_printSet1();
}
if (Ze_mode == "printSet2") {
	translate([10, 12, 0]) 
	H_Z_end(hasCrossBrace = false);
	translate([-10, -12, 0]) 
	rotate(a=180,v=[0,0,1]) 
	H_Z_end(hasCrossBrace = false);
}
if (Ze_mode == "print Left") {
	H_Z_end(hasCrossBrace = false);
}
if (Ze_mode == "print right") {
	H_Z_end(hasCrossBrace = true);
}



/*------------------------------------assembly--------------------------------*/
include <basicMetalParts.scad>

module _H_Z_end_assembly(hasCrossBrace = false) {
	translate([0, 0, Ze_roughRod_diam/2+Ze_genWallThickness]){
		rotate(a=180,v=X) 
		H_Z_end(hasCrossBrace = hasCrossBrace);
		translate([-Ze_zEnd_rodsDist, 0, -Ze_bear_heigth]) 
			bear608ZZ(info = "z end");
	}
}


module H_Z_endLeft_assembly() {
	_H_Z_end_assembly(hasCrossBrace = false);
}
module H_Z_endright_assembly() {
	rotate(a=180,v=Z) 
	_H_Z_end_assembly(hasCrossBrace = true);

	translate([Ze_zEnd_rodsDist + _Ze_crosBr_bearing_dist, 0, 0]) 
	rotate(a=90,v=X) 
	threadedRod(r=4, h=100+50, center=true,info = "z end cross brace rod connector");  // todo
}

if (Ze_mode == "assembly"){
	//H_Z_endLeft_assembly();
	H_Z_endright_assembly();
}





module _triangle2hg(height,ground)
{
    polygon(points=[[-ground/2,0],[ground/2,0],[0,height]], paths=[[0,1,2]]);
}