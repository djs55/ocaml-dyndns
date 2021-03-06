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

module Update : sig
  type t = {
    username: string;
    password: string;
    user_agent: string; (** our user-agent (application name) *)
    server: string; (** hostname of remote service *)
    hostnames: string list; (** a list of hostnames to be changed at once *)
    ips: Ipaddr.t list; (** every hostname is associated with this list of IP addresses *)
  }
  (** A single dynamic DNS update request *)

  val of_string: string -> (t, [ `Msg of string ]) result

  val to_string: t -> string
end