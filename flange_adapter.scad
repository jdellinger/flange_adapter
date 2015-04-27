base_radius=60;
base_height=5;
hub_bolt_radius=51.039;
riser_height=15;
riser_outer_radius=25;
riser_inner_radius=20;
bearing_diameter=38;
top_height=5;
top_radius=45;
top_bolt_radius=35.638;
fillet_radius=25;
//$fn=100;

module base_plate(){
    difference(){
        cylinder(h=base_height, r=base_radius);
        rotary_holes(5, hub_bolt_radius, 8);
        base_plate_cutout();
    }
}

module base_plate_cutout(){
    rotate(360/10)
        rotary_holes(5, base_radius, 40);
}

module riser(){
    translate([0, 0, base_height])
        difference(){
            cylinder(h=riser_height,r=riser_outer_radius);
            cylinder(h=riser_height,r=riser_inner_radius);
        }
}

module top_plate(){
    translate([0,0,base_height+riser_height]){
        difference(){
            top_disc_with_fillet();
            top_plate_bolt_holes();
            top_plate_cutout();
        }
    }
}

module top_plate_bolt_holes(){
    rotary_holes(4, top_bolt_radius, 8);
}

module top_plate_cutout(){
    rotate(360/8)
        rotary_holes(4, top_radius, 40);
}

module top_disc_with_fillet(){
    cylinder(h=top_height, r=top_radius);
    translate([0,0,-riser_height]){
        top_plate_fillet();
    }
}

module rotary_holes(n, radius, hole_diameter){
    for (i = [0:n]) {
        rotate(i*360/n)
            translate([0,radius,0])
                cylinder(h=100, d=hole_diameter);
    }
}

module top_plate_fillet(){
    //need to add cylinder with subtracted torus to create underhang fillet
    translate([0,0,-(fillet_radius-riser_height)])
        difference(){
            translate([0,0,fillet_radius-riser_height])
                cylinder(h=riser_height,r=top_radius);
            cylinder(h=riser_height,r=riser_outer_radius);
            rotate_extrude()
                translate([top_radius,0,0])
                    circle(r=fillet_radius);
            top_plate_cutout();
            top_plate_bolt_holes();
        }
}

module full_adapter(){
    difference(){
        union(){
            base_plate();
            riser();
            top_plate();
        }
        cylinder(h=base_height+riser_height+top_height, d=bearing_diameter);
    }
}

module base_test(){
    difference(){
        union(){
            base_plate();
        }
        cylinder(h=base_height+riser_height+top_height, d=bearing_diameter);
    }
}

full_adapter();
//base_test();
//top_plate_fillet();
