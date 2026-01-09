-- We need this for prosody 13.0
component_admins_as_room_owners = true

plugin_paths = { "/usr/share/jitsi-meet/prosody-plugins/" }

-- domain mapper options, must at least have domain base set to use the mapper
muc_mapper_domain_base = "evalynx-meet.duckdns.org";

external_service_secret = "3aFy5RmsRgMEEgHb";
external_services = {
     { type = "stun", host = "evalynx-meet.duckdns.org", port = 3478 },
     { type = "turn", host = "evalynx-meet.duckdns.org", port = 3478, transport = "udp", secret = true, ttl = 86400, algorithm = "turn" },
     { type = "turns", host = "evalynx-meet.duckdns.org", port = 5349, transport = "tcp", secret = true, ttl = 86400, algorithm = "turn" }
};

cross_domain_bosh = false;
consider_bosh_secure = true;
consider_websocket_secure = true;
-- https_ports = { }; -- Remove this line to prevent listening on port 5284

-- by default prosody 0.12 sends cors headers, if you want to disable it uncomment the following (the config is available on 0.12.1)
--http_cors_override = {
--    bosh = {
--        enabled = false;
--    };
--    websocket = {
--        enabled = false;
--    };
--}

-- https://ssl-config.mozilla.org/#server=haproxy&version=2.1&config=intermediate&openssl=1.1.0g&guideline=5.4
ssl = {
    protocol = "tlsv1_2+";
    ciphers = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
}

unlimited_jids = {
    "focus@auth.evalynx-meet.duckdns.org",
    "jvb@auth.evalynx-meet.duckdns.org"
}

-- https://prosody.im/doc/modules/mod_smacks
smacks_max_unacked_stanzas = 5;
smacks_hibernation_time = 60;
smacks_max_old_sessions = 1;

VirtualHost "evalynx-meet.duckdns.org"
    authentication = "jitsi-anonymous" -- do not delete me
    -- Properties below are modified by jitsi-meet-tokens package config
    -- and authentication above is switched to "token"
    --app_id="example_app_id"
    --app_secret="example_app_secret"
    -- Assign this host a certificate for TLS, otherwise it would use the one
    -- set in the global section (if any).
    -- Note that old-style SSL on port 5223 only supports one certificate, and will always
    -- use the global one.
    ssl = {
        key = "/etc/prosody/certs/evalynx-meet.duckdns.org.key";
        certificate = "/etc/prosody/certs/evalynx-meet.duckdns.org.crt";
    }
    -- we need bosh
    modules_enabled = {
        "bosh";
        "websocket";
        "smacks";
        "ping"; -- Enable mod_ping
        "external_services";
        "features_identity";
        "conference_duration";
        -- "muc_lobby_rooms"; -- disabled
        "muc_breakout_rooms";
    }
    c2s_require_encryption = false
    lobby_muc = "lobby.evalynx-meet.duckdns.org"
    breakout_rooms_muc = "breakout.evalynx-meet.duckdns.org"
    main_muc = "conference.evalynx-meet.duckdns.org"
    -- muc_lobby_whitelist = { "recorder.evalynx-meet.duckdns.org" } -- Here we can whitelist jibri to enter lobby enabled rooms

Component "conference.evalynx-meet.duckdns.org" "muc"
    restrict_room_creation = true
    storage = "memory"
    modules_enabled = {
        "muc_hide_all";
        "muc_meeting_id";
        "muc_domain_mapper";
        --"token_verification";
        "muc_rate_limit";
        "muc_password_whitelist";
        -- -- "muc_lobby_rooms"; -- disabled -- disabled
    }
    admins = { "focus@auth.evalynx-meet.duckdns.org" }
    muc_password_whitelist = {
        "focus@auth.evalynx-meet.duckdns.org"
    }
    muc_room_locking = false
    muc_room_default_public_jids = true

Component "breakout.evalynx-meet.duckdns.org" "muc"
    restrict_room_creation = true
    storage = "memory"
    modules_enabled = {
        "muc_hide_all";
        "muc_meeting_id";
        "muc_domain_mapper";
        "muc_rate_limit";
        --"polls";
    }
    admins = { "focus@auth.evalynx-meet.duckdns.org" }
    muc_room_locking = false
    muc_room_default_public_jids = true

-- internal muc component
Component "internal.auth.evalynx-meet.duckdns.org" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_hide_all";
        "ping";
    }
    admins = { "focus@auth.evalynx-meet.duckdns.org", "jvb@auth.evalynx-meet.duckdns.org" }
    muc_room_locking = false
    muc_room_default_public_jids = true

VirtualHost "auth.evalynx-meet.duckdns.org"
    modules_enabled = {
        "limits_exception";
        "smacks";
    }
    authentication = "internal_hashed"
    smacks_hibernation_time = 15;

VirtualHost "recorder.evalynx-meet.duckdns.org"
    modules_enabled = {
      "smacks";
    }
    authentication = "internal_hashed"
    smacks_max_old_sessions = 2000;

-- Proxy to jicofo's user JID, so that it doesn't have to register as a component.
Component "focus.evalynx-meet.duckdns.org" "client_proxy"
    target_address = "focus@auth.evalynx-meet.duckdns.org"

Component "speakerstats.evalynx-meet.duckdns.org" "speakerstats_component"
    muc_component = "conference.evalynx-meet.duckdns.org"

Component "endconference.evalynx-meet.duckdns.org" "end_conference"
    muc_component = "conference.evalynx-meet.duckdns.org"

Component "avmoderation.evalynx-meet.duckdns.org" "av_moderation_component"
    muc_component = "conference.evalynx-meet.duckdns.org"

Component "filesharing.evalynx-meet.duckdns.org" "filesharing_component"
    muc_component = "conference.evalynx-meet.duckdns.org"

Component "lobby.evalynx-meet.duckdns.org" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = {
        "muc_hide_all";
        "muc_rate_limit";
    }

Component "metadata.evalynx-meet.duckdns.org" "room_metadata_component"
    muc_component = "conference.evalynx-meet.duckdns.org"
    breakout_rooms_component = "breakout.evalynx-meet.duckdns.org"

Component "polls.evalynx-meet.duckdns.org" "polls_component"
