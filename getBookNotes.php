<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }

     $username= isset($_POST['username']) ? $_POST['username'] : '';
     $book_id= isset($_POST['book_id']) ? $_POST['book_id'] : '';

    $result = $db->query("SELECT * FROM users_book_notes WHERE username = '" .$username. "' AND book_id = '" .$book_id. "'");
    if($result) {
      $row = mysqli_fetch_object($result);
        echo json_encode($row);
    }
?>