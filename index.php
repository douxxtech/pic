<?php

$baseUrl = 'https://raw.githubusercontent.com/douxxtech/pic/refs/heads/main/';

$file = $_SERVER['QUERY_STRING'] ?? 'pic';

if (!preg_match('/^[a-zA-Z0-9_-]+$/', $file)) {
    http_response_code(400);
    exit("Invalid filename.");
}

$url = $baseUrl . $file . '.sh';

$options = [
    "http" => [
        "method" => "GET",
        "header" => "User-Agent: pic\r\n"
    ]
];

$context = stream_context_create($options);
$content = @file_get_contents($url, false, $context);

if ($content !== false) {
    $content = str_replace(["\r\n", "\r"], "\n", $content);

    header('Content-Type: text/plain');
    echo $content;
} else {
    http_response_code(404);
    echo "echo \"error while fetching {$file}.sh\"";
}
