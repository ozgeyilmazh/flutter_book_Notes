<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }

   $username= isset($_POST['username']) ? $_POST['username'] : '';

    $result = $db->query("SELECT * FROM user_datas WHERE username = '" .$username. "'");
    $list = array();
    if($result) {
        while($row = mysqli_fetch_assoc($result)){
            $list[] = $row;
        }
        echo json_encode($list);
    }
?>