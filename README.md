# robot_arm_mouse
control 4 DOF robot arm using mouse, thought Processing

<img width = 300px src="https://lh5.googleusercontent.com/-iVy9mOLFt-U/VWfRbBA9vFI/AAAAAAAAFsc/1umu8NvZ1Gg/w1582-h1224-no/dh%2Bgraph.jpg">

the define servo angles are 90, using a servo tester, set the angle to 90, see if the robot align the dh graph above
if not, find the inputing angle that the real robot arm angles are 90 degree

<img width = 300px src="https://lh5.googleusercontent.com/-MT0lwcSzgUA/VWfRhwKsc0I/AAAAAAAAFsw/HYpVGNuK0ZU/w1102-h1224-no/%25E8%259E%25A2%25E5%25B9%2595%25E5%25BF%25AB%25E7%2585%25A7%2B2015-05-29%2B%25E4%25B8%258A%25E5%258D%258810.33.19.png">

Open the Processing code, find the above array
<p>
the perimeter are min. angle, standard angle(90), max. angle and direction respectively.
<p> for the direction, 0 means your servo direction is same as the dh graph, 1 means it is oppositive to the direction shown in the dh graph
