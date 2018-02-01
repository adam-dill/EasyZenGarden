<?php

$fname = $_POST['fileName'];

var_dump($fname);

$file = fopen($fname.'.txt', 'w');
fwrite($file, $_POST['levels']);
fclose($file);
?>