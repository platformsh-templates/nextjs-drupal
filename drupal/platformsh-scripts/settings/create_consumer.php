<?php

use Drupal\consumers\Entity\Consumer;

$id = 'nextjs-site';
$label = 'Next.js site';
$description = "This is the Next.js consumer. This was created programmatically by Platform.sh during the first deploy to configure multi-app. Please do not delete.";

$user_id = $extra[0];
$secret = $extra[1];
$site = "nextjs site";

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
