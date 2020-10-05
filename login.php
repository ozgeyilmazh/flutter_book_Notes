<?php
    $db = mysqli_connect('localhost', 'root','','book_notes');

    if(!$db){
        echo "database connection failed";
    }
    $username= isset($_POST['username']) ? $_POST['username'] : '';
    $password= isset($_POST['password']) ? $_POST['password'] : '';

   $sql = "SELECT * FROM user_datas WHERE username = '" .$username. "' AND password = '" .$password. "' AND level = 'admin'";
   $sql2 = "SELECT * FROM user_datas WHERE username = '" .$username. "' AND password = '" .$password. "' AND level = 'member'";

  $result = mysqli_query($db,$sql);
  $count = mysqli_num_rows($result);
  $result2 = mysqli_query($db,$sql2);
  $count2 = mysqli_num_rows($result2);
  	if ($count == 1) {
  		echo json_encode("Success1");
  	}
  	else if ($count2 == 1) {
      		echo json_encode("Success2");
      	}else{
           		echo json_encode("Error");
           	}

?>