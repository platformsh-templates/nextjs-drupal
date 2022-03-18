<?php

use Drupal\consumers\Entity\Consumer;

$user_id = $extra[0];
$id = $extra[1];
$label = $extra[2];
$description = $extra[3];
$site = $extra[4];
$secret = $extra[5];

$site = Consumer::create([
    'id'                => $id,
    'label'             => $label,
    'description'       => $description,
    'user_id'           => $user_id,
    'roles'             => $site,
    'secret'            => $secret,
]);

$site->save();
echo $site->uuid();
