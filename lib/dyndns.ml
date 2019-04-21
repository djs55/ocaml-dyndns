(*
 * Copyright (C) 2019 David Scott
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *)

module Update = struct
  type t = {
    username: string;
    password: string;
    user_agent: string;
    server: string;
    hostnames: string list;
    ips: Ipaddr.t list;
  }

  (*
  GET /nic/update?hostname=yourhostname&myip=ipaddress&wildcard=NOCHG&mx=NOCHG&backmx=NOCHG HTTP/1.0
  Host: members.dyndns.org
  Authorization: Basic base-64-authorization
  User-Agent: Company - Device - Version Number
  *)
  let to_string update =
    Printf.sprintf "GET /nic/update?%s HTTP/1.0\r\nHost: %s\r\nAuthorization: %s\r\nUser-agent: %s\r\n"
      (Uri.encoded_of_query ["hostname", update.hostnames; "myip", List.map Ipaddr.to_string update.ips])
      update.server
      ("Basic " ^ (B64.encode (Printf.sprintf "%s:%s" update.username update.password)))
      update.user_agent

  let of_string string =
    let module R = Cohttp.Request.Make(String_io.M) in
    let buf = String_io.open_in string in
    match R.read buf with
    | `Eof -> Error (`Msg "EOF reading HTTP request")
    | `Invalid x -> Error (`Msg x)
    | `Ok req ->
      let user_agent = match Cohttp.Header.get req.Cohttp.Request.headers "user-agent" with None -> "" | Some x -> x in
      Ok {
        username = "";
        password = "";
        user_agent;
        server = "";
        hostnames = [];
        ips = [];
      }
end