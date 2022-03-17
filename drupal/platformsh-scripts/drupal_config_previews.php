<?php

use Drupal\next\Entity\NextEntityTypeConfig;

$id = 'node.article';
$site_resolver = 'site_selector';
$site = 'blog';
$entity_type_config = NextEntityTypeConfig::create([
    'id'                => $id,
    'site_resolver'     => $site_resolver,
    'configuration' => [
        'sites' => [
          $site => $site,
        ],
      ],

]);
$entity_type_config->save();
