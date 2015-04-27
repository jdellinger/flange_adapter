//base_radius=60;
base_height=5;
hub_bolt_radius=51;
riser_height=15;
riser_outer_radius=30;
riser_inner_radius=21;
bearing_diameter=42;
top_height=5;
//top_radius=45;
top_bolt_radius=35.638;
fillet_radius=25;
outer_leaf_radius=10;
inner_leaf_radius=30;
bolt_diameter=9;
$fn=100;

wheel_portion();
//flange_portion_for_print();
//full_adapter();

module wheel_portion(){
    difference(){
        union(){
            base_plate();
            translate([0, 0, base_height]) riser();
            //translate([0,0,base_height+riser_height]) top_plate();
            //translate([0,0,base_height]) top_plate_fillet();
        }
        translate([0,0,base_height]) mating_sockets();
        cylinder(h=base_height+riser_height+top_height, d=bearing_diameter);
    }
}

module flange_portion_for_print(){
        rotate([0,180,0])
            translate([0,0,-(base_height+riser_height+top_height)])
                flange_portion();
}

module flange_portion(){
    difference(){
        union(){
            //base_plate();
            //translate([0, 0, base_height]) riser();
            translate([0,0,base_height+riser_height]) top_plate();
            translate([0,0,base_height]) mating_sockets();
        }
        cylinder(h=base_height+riser_height+top_height, d=bearing_diameter);
    }
}

module mating_sockets(){
    step=1;
    n=3;
    w=riser_outer_radius-riser_inner_radius-3;
    for (i = [0:step:n-1]) {
        rotate(i*360/n)
            translate([0,0,riser_height/2])
                partial_rotate_extrude(360/(n*2), (riser_outer_radius+riser_inner_radius)/2, 10)
                    square([w,riser_height], center=true);
//                cube([w, w, riser_height], center=true);
    }
}

module pie_slice(radius, angle, step) {
    for(theta = [0:step:angle-step]) {
        rotate([0,0,0]) linear_extrude(height = radius*2, center=true)
        polygon( points = [[0,0],[radius * cos(theta+step) ,radius * sin(theta+step)],[radius*cos(theta),radius*sin(theta)]]);
    }
}
module partial_rotate_extrude(angle, radius, convex) {
    intersection () {
        rotate_extrude(convexity=convex) translate([radius,0,0]) child(0);
        pie_slice(radius*2, angle, angle/5);
    }
}

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



