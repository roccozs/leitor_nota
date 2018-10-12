<?php 
$uploaddir = '/home/bolinhab/public_html/ocr/';
$uploadfile = $uploaddir . basename($_FILES['image']['name']);
$filename = $_FILES['image']['name'];
$ext = pathinfo($filename, PATHINFO_EXTENSION);

$uploadfile = $uploaddir . basename('teste.'.$ext); 

if (file_exists('/home/bolinhab/public_html/ocr/teste.png')) {
    unlink('/home/bolinhab/public_html/ocr/teste.png');
}

    if (file_exists('/home/bolinhab/public_html/ocr/comprimida.jpg')) {
               unlink('/home/bolinhab/public_html/ocr/comprimida.jpg');
    }
    
move_uploaded_file($_FILES["image"]["tmp_name"], $uploadfile);






$source_img = '/home/bolinhab/public_html/ocr/teste.png';
$destination_img = '/home/bolinhab/public_html/ocr/comprimida.jpg';

$d = compress($source_img, $destination_img, 90);




function compress($source, $destination, $quality) {

    $info = getimagesize($source);

    if ($info['mime'] == 'image/jpeg') 
        $image = imagecreatefromjpeg($source);

    elseif ($info['mime'] == 'image/gif') 
        $image = imagecreatefromgif($source);

    elseif ($info['mime'] == 'image/png') 
        $image = imagecreatefrompng($source);

    imagejpeg($image, $destination, $quality);

    return $destination;
}