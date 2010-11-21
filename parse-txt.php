<?php
/**
 * @file script to reformat exported txt files from njvan for Solr CSV loader.
 */

/**
 * Copyright 2010 Peter Wolanin. All Rights Reserved
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 *    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

ini_set('display_startup_errors', 1);
ini_set('display_errors', 1);
ini_set('auto_detect_line_endings', 1);

if (empty($argv[1]) || !file_exists($argv[1])) {
  die ("Please specify the input file\n{$argv[0]} <input file>\n");
}

ini_set('memory_limit', '512M');

date_default_timezone_set('UTC');
$handle = fopen($argv[1], 'r');

$row = 0;
$fp = fopen('php://stdout', 'w');
$date_fields = array('DOR' => -1, 'DOB' => -1, 'RequestReceived' => -1);

while (($data = fgetcsv($handle, 5000, "\t")) !== FALSE) {
  if ($row > 0) {
    foreach($date_fields as $idx) {
      if (!empty($data[$idx])) {
        $data[$idx] = gmdate('Y-m-d\TH:i:s\Z', strtotime($data[$idx]));
      }
    }
  }
  else {
    // Parse the header row.
    // Look in header row to find date fields
    foreach ($data as $idx => &$name) {
      $name = trim($name);
      // Remove internal spaces from field names
      $name = strtr($name, array(' ' => ''));
      if (isset($date_fields[$name])) {
        $date_fields[$name] = $idx;
      }
    }
  }
  fputcsv($fp,$data);
  $row++;
}
