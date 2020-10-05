<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }

   $username= isset($_POST['username']) ? $_POST['username'] : '';
   $book_id= isset($_POST['book_id']) ? $_POST['book_id'] : '';
   $books_name= isset($_POST['books_name']) ? $_POST['books_name'] : '';
   $author= isset($_POST['author']) ? $_POST['author']  : '';

   $sql = "SELECT * FROM users_book_list WHERE book_id = '" .$book_id. "' AND username = '" .$username. "' ";

  $result = mysqli_query($db,$sql);
  $count = mysqli_num_rows($result);

  	if ($count == 1) {
  		echo json_encode("Error");
  	}else{
  		$insert = "INSERT INTO users_book_list(book_id,username,books_name,author)VALUES('".$book_id."', '".$username."', '" .$books_name. "', '" .$author. "')";
  		$query = mysqli_query($db,$insert);
  		if ($query) {
  			echo json_encode("Success");
  		}
  	}

?>