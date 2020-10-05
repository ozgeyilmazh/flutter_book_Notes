<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }

   $username= isset($_POST['username']) ? $_POST['username'] : '';
   $book_id= isset($_POST['book_id']) ? $_POST['book_id'] : '';
   $books_name= isset($_POST['books_name']) ? $_POST['books_name'] : '';
   $author= isset($_POST['author']) ? $_POST['author']  : '';

    $result = $db->query("SELECT book_id, books_name, author FROM users_book_list WHERE username = '" .$username. "'");
    $list = array();
    if($result) {
        while($row = mysqli_fetch_assoc($result)){
            $list[] = $row;
        }
        echo json_encode($list);
    }
?>