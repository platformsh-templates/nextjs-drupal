<?php

// Besides the first deploy, this will already exist. 
// If on the same environment, this isn't an issue.
// Id on a different environment, will need to delete/re-define.

use Drupal\next\Entity\NextSite;

$id = 'blog';
$label = 'Blog';
$base_url = getenv("FRONTEND_URL");
$preview_url= "$base_url/api/preview";
$preview_secret = $extra[0];

$site = NextSite::create([
    'id'                => $id,
    'label'             => $label,
    'base_url'          => $base_url,
    'preview_url'       => $preview_url,
    'preview_secret'    => $preview_secret,
]);
$site->save();
