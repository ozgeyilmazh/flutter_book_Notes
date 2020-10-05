<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }

   $books_name= isset($_POST['books_name']) ? $_POST['books_name'] : '';
   $author= isset($_POST['author']) ? $_POST['author']  : '';

   $sql = "SELECT * FROM books WHERE books_name = '" .$books_name. "' AND author = '" .$author. "'";

  $result = mysqli_query($db,$sql);
  $count = mysqli_num_rows($result);

  	if ($count == 1) {
  		echo json_encode("Error");
  	}else{
  		$insert = "INSERT INTO books(books_name,author)VALUES('" .$books_name. "', '" .$author. "')";
  		$query = mysqli_query($db,$insert);
  		if ($query) {
  			echo json_encode("Success");
  		}
  	}

?>