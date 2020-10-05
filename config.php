<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }
   else {
        echo "Connection succesfull";
   }

?>