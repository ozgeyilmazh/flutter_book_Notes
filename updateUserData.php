<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }
    $name= isset($_POST['name']) ? $_POST['name'] : '';
    $email= isset($_POST['email']) ? $_POST['email'] : '';
    $username= isset($_POST['username']) ? $_POST['username'] : '';
    $password= isset($_POST['password']) ? $_POST['password'] : '';

   $sql = "SELECT * FROM user_datas WHERE username = '" .$username. "'";

  $result = mysqli_query($db,$sql);
  $count = mysqli_num_rows($result);

  	if ($count == 1) {
  		$insert1 = "UPDATE user_datas SET name= '".$name."' ,  email='".$email."' ,username= '".$username."' ,  password = '" .$password. "' WHERE username = '" .$username. "'";
          		$query1 = mysqli_query($db,$insert1);
          		if ($query1) {
          			echo json_encode("Success");
          		}
  	}else{
  		echo json_encode("Error");
  	}

?>