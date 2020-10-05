<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }
    $username= isset($_POST['username']) ? $_POST['username'] : '';
    $book_id= isset($_POST['book_id']) ? $_POST['book_id'] : '';
    $books_note= isset($_POST['books_note']) ? $_POST['books_note'] : '';

   $sql = "SELECT * FROM users_book_notes WHERE username = '" .$username. "' AND book_id = '" .$book_id. "'";

  $result = mysqli_query($db,$sql);
  $count = mysqli_num_rows($result);

  	if ($count == 1) {
  		$insert1 = "UPDATE users_book_notes set username= '".$username."' ,  book_id='".$book_id."' ,  books_note = '" .$books_note. "' WHERE username = '" .$username. "' AND book_id = '" .$book_id. "'";
          		$query1 = mysqli_query($db,$insert1);
          		if ($query1) {
          			echo json_encode("Success1");
          		}
  	}else{
  		$insert2 = "INSERT INTO users_book_notes(username,book_id,books_note) VALUES('".$username."','".$book_id."', '" .$books_note. "')";
  		$query2 = mysqli_query($db,$insert2);
  		if ($query2) {
  			echo json_encode("Success2");
  		}
  	}

?>