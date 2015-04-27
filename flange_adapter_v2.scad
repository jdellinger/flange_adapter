//base_radius=60;
base_height=5;
hub_bolt_radius=51.039;
riser_height=15;
riser_outer_radius=25;
riser_inner_radius=20;
bearing_diameter=38;
top_height=5;
//top_radius=45;
top_bolt_radius=35.638;
fillet_radius=25;
outer_leaf_radius=10;
inner_leaf_radius=25;
bolt_diameter=8;
$fn=100;

full_adapter();

module full_adapter(){
    difference(){
        union(){
            base_plate();
            translate([0, 0, base_height]) riser();
            translate([0,0,base_height+riser_height]) top_plate();
            translate([0,0,base_height]) top_plate_fillet();
        }
        cylinder(h=base_height+riser_height+top_height, d=bearing_diameter);
    }
}

module base_plate(){
    difference(){
        rotary_leafs(5, base_height, hub_bolt_radius, outer_leaf_radius, inner_leaf_radius, 2);
        rotary_holes(5, hub_bolt_radius, bolt_diameter);
    }
}

module top_plate(height=top_height){
    difference(){
        rotary_leafs(4, height, top_bolt_radius, outer_leaf_radius, inner_leaf_radius);
        rotary_holes(4, top_bolt_radius, bolt_diameter);
    }
}

module top_plate_fillet(){
    difference(){
        top_plate(riser_height);
        translate([0,0,riser_height-fillet_radius]) rotate_extrude()
            translate([top_bolt_radius+outer_leaf_radius,0,0])
                circle(r=fillet_radius);
    }
}

module rotary_leafs(n, height, radius, outer_radius, center_radius, step=1){
    for (i = [0:step:n-1]) {
        rotate(i*360/n)
            hull(){
                translate([0,radius,0])
                    cylinder(h=height, r=outer_radius);
                cylinder(h=height, r=center_radius);
            }
    }
}

module rotary_holes(n, radius, hole_diameter){
    for (i = [0:n]) {
        rotate(i*360/n)
            translate([0,radius,0])
                cylinder(h=100, d=hole_diameter);
    }
}

module riser(){
    difference(){
        cylinder(h=riser_height,r=riser_outer_radius);
        cylinder(h=riser_height,r=riser_inner_radius);
    }
}



