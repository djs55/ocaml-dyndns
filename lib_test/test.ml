
let test_docker_dynamic_dns () =
    (* Can we parse request from https://github.com/theonemule/docker-dynamic-dns *)
    let request = [
        "GET /v3/update?hostname=host.docker.internal&myip=80.6.181.77 HTTP/1.1";
        "User-Agent: no-ip shell script/1.0 mail@mail.com";
        "Accept: */*";
        "Accept-Encoding: identity";
        "Host: localhost";
        "Connection: Keep-Alive";
        "Authorization: Zm9vOmJhcgo=";
    ] in
    match Dyndns.Update.of_string @@ String.concat "" @@ List.map (fun x -> x ^ "\r\n") request with
    | Error (`Msg m) -> failwith m
    | Ok result ->
        Alcotest.(check (list string)) "hostnames" ["host.docker.internal"] result.hostnames;
        Alcotest.(check (list string)) "ips" ["80.6.181.77"] (List.map Ipaddr.to_string result.ips);
        Alcotest.(check string) "user-agent" "no-ip shell script/1.0 mail@mail.com" result.user_agent;
        Alcotest.(check string) "server" "localhost" result.server;
        Alcotest.(check string) "username" "foo" result.username;
        Alcotest.(check string) "password" "bar" result.password

let parser = [
    "from theonemule/docker-dynamic-dns", `Quick, test_docker_dynamic_dns
]

let () =
  Alcotest.run "dyndns" [
    "parser", parser;
  ]