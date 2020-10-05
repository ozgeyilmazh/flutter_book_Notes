<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }
    $username= isset($_POST['username']) ? $_POST['username'] : '';
    $password= isset($_POST['password']) ? $_POST['password'] : '';
    $email= isset($_POST['email']) ? $_POST['email'] : '';
    $name= isset($_POST['name']) ? $_POST['name'] : '';



   $sql = "SELECT * FROM user_datas WHERE username = '" .$username. "' OR email = '" .$email. "' ";

  $result = mysqli_query($db,$sql);
  $count = mysqli_num_rows($result);

  	if ($count == 1) {
  		echo json_encode("Error");
  	}else{
  		$insert = "INSERT INTO user_datas(username,password,name,email,level)VALUES('".$username."','".$password."', '".$name."' , '".$email."' ,'member')";
  		$query = mysqli_query($db,$insert);
  		if ($query) {
  			echo json_encode("Success");
  		}
  	}

?>