<!DOCTYPE html>
<html>
  <head>
    <title>Apache,mysql,PHP</title>
  </head>
<body>
  <div class="container">
    <h1>Hello from DOCKER</h1>

    <form method="post">
      <input name="submit" type="submit" value="Check" style="background-color: red;">
    </form>


    <?php

      if (isset($_POST['submit'])) {
        $host = 'db';
        $user = 'root';
        $password = 'guntantin';

        $conn = new mysqli($host,$user,$password,);
        if($conn->connect_error){
          echo 'connection failed' . $conn->connect_error;
        }
        echo 'Successfully connected to MYSQL' ;
      }
    ?>

  </div>
</body>
</html>
