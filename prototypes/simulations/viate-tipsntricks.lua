local out = {}
out.welcome = {
  planet = "pktff-viate",
  -- generate_map = true,
  mods = {"pk-the-first-frontier"},

  -- Instead of manually placing things (cringe!) just generate a map.
  -- I scouted this location ahead of time.
  -- TODO this doesn't work at all
  init = [[
    local map_string = ">>>eNp1U7+LE0EUnrkYciZ3Z5AgCHJJcZ1E8LSwkOwqiIjov7BONpM4uJmJ8yPHKWKKKxUbG6/xWptrxEKrA0EUFA6trjuxsVCJKNoIcSabSXY2uYF5+fZ9b95735vJHADgJMgAUC6i24pELAi5auCAkQiAnmd3LkRRSCRO+g6FDDlB+ZB1OphXGXfiDg8zVlMZ85ji9nq1joQTvNiMFOOE4qCLqXQZFbUYR0EYkWYzyRyxDBERog2R5AqtCNdnnCnG/mETQbqJhZjs6GxyVjYhGcUz/GtIYp70zxPOaHoeixGRN4lqB3Wj06lLkeoSMd1tlrPwltNJVoQcdZKeY0IiLgltBYhjFLQZEVK5lbNTjZeEipqKkzBAIWkELbwuXAVZyTF2Ki9IRVtCYhqkdBUUR1TrSustdImeixkyoc4cYn8bS8y4U2IpZkSHSYqFcA+pKERU6SGlXt/RMdNlBhDRdoRMXQ6A5b3na72NZWD24D6oDAZma7Sv/xVmA9iLo6F22pUdXQ+oXND74iQdhHdL25c/33nswTjylD8C/ZFnp249Vyy47h9IrVhwNpHnzHD9SoC4qNQlRlHz/gTE5IYhIXz4/cXW3ze7Nfjv2c+P1+o3PHj6UulHf3W7psmckTs3NptPzHpppQCbc98bUXse/PDerG8ezJoTJWP8c9rsXM0AWFzSaOuBNpUTwLZWs2lKPmwO1x+r5IsFn7y0Dj2I8yb5sjFvjRkWHHcGY+g/8qFftuzxSYg+vwqSPTQmCt/Zsq8T9VONTF9EUkfKs+LPuIa8KdgYm6+ZcTd6nrs5++U/9WHGABP1W/viL8PYVPFv0R+OOzN+lH3PfWkGmCSb9171/gMm8lBF<<<"
    local mesd = helpers.parse_map_exchange_string(map_string)
    game.surfaces[1].map_gen_settings = mesd.map_gen_settings

    for cx = -2,3 do
      for cy = -2,3 do
        -- game.surfaces[1].delete_chunk{x=cx, y=cy}
        -- game.surfaces[1].request_to_generate_chunks{x=cx*32, y=cy*32}
      end
    end
  ]]
}

out.dust = {
  planet = "pktff-viate",
  generate_map = false,
  checkerboard = true,
  -- This is the secret sauce to get scripts to run
  mods = {"pk-the-first-frontier"},

  -- default size is 22 across, 11 tall
  init = [[
    game.surfaces[1].create_global_electric_network()
    for dx = -11,-1 do
      for dy = -5,7 do
        game.surfaces[1].create_entity{
          name="pktff-ice-deposit", position={dx, dy},
          amount=9999999999999
        }
      end
    end

    local bp = "0eNrNmV1ymzAQx++iZ8joW8JX6WQYbGRHMyA8Qk7rZnyAHqQX60kqIHGaBOoVT86Dsxbit6s/2kWSX9C2OZmjty6gzQuyu871aPPtBfX24KpmaHNVa9AGbe0hb62z7pDX3jYNumTIutr8QBtyecyQccEGa6a7xy/n0p3arfGxQ7ZIydCx6+ONnRt8RVguHkSGztFQDyL6qK03u+m6vmRf0PSKDr5y/bHzId+aJvwPzCFglhKzfkPTz2g+g+YrYqaQmMUKMIOAZYoYdDFmQmfY6so2Tezo7S43zvjDOY+T0vh9tTMzTgiffJDoYXva740ve/szUgi+/s0401dnfeicyb9Xs0Mg5G0MOI5hhlOkcsg8h+AVjwxDHhkhK8gERH7Pub6N486bqj1+pZKP0FhZgu+acmueqmfb+aHXzvrdyYbSuGrbmBptgj+Z7Nocb6mvxL31fSjfy1I4H4cInq0Pp2rQ/i2ksUdeuXN4irMUTa77UA0Vjgxf2mPlqzBEgP78+o0uY49miih+4AdNhNSSasELoYTGQkqOJY3DOcTLcb6Nn9VQ+ObkYSB52B3KwwDykEmFBz6JpArBBC2YUAXBsWlQ6YY+HKQPvUN9KFyfmyoIkAriDlUQCbNkOZVuyCNB8vA7lIcnyKOw0JoyhbkiheCMC4UZAcijQPKoO5RHgUowHXWJiiitMKZCMq6kuNbg9fNKg4STdyicBAknsdKcERnFKKiiXOKCqUk1clOcAiSOvkNxNEQcmAoUg9Z2BN9YIlKSyFlYIlKauNZc4rBEztK4VmxflkJasWHBkB0WlXAwTwIrOJgmgTUczJLABRyMU8AsYetCksDwncsy9/91yZuqLp8qVw+lKET//UyJGtunrm1Xm4VyweAnEGnyMjA3aT4wePomTWAGz+WkVGbwVE7KZAbPZJXEhSeyTOLC87hI4XJ4GuskbkIWJyUGp2nv1YV3D3/PL+v21sVr+e7J9HPxfUywt+5lb0KIK5F+XF+Ytns25Slea4Lxpi5tMO1rWZn1/56HTVfVsemrX7pY3F4XSdYdTwHN0UXiy54uqCTXHIMy0HNU6S//pSh1OootoIo1R50MdNIpEleWC6MVK072+AJqxfG5WECxNYf8eoA9Zuh7lG746eBbnPMkIzwjj9lkx9XAaLN/2kdbTrb4bOvJVp/tItrR05CWQ4zXnz0y9Gx8P8YWN5gFL4r4jxVMssvlLwpgLek="
    local ret = game.surfaces[1].create_entities_from_blueprint_string{
      string = bp, position = {-1, 0},
    }

    log(game.surfaces[1].pollutant_type.name)

    -- Sigh. Raise the script built events by hand
    for _,e in ipairs(game.surfaces[1].find_entities_filtered{name="big-mining-drill"}) do
      script.raise_script_built{entity=e}
    end
  ]],
  update = [[
    -- Every second it gets 1% slower
    if game.tick % 60 == 0 then
      game.surfaces[1].pollute({0, 0}, 10)
    end
  ]]
}

return out
