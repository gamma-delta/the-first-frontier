local intro = {
  checkerboard = true,
  planet = "nauvis",
  init_update_count = 300,
  init = [[
    game.surfaces[1].create_global_electric_network()
    game.forces.player.enable_all_recipes()

    local bp = "0eNqtmdtuozAQht/F11CBDxzyKqsqIsRJrQWbtU232SrvvkOyDWkL64OSO7D9zT/Gh3+Ud7TrRj5oIS3avCPRKmnQ5sc7MuIom256J5ueow3Sqv3JbWpEp9A5QULu+Rva5OfnBHFphRX8OvDycNrKsd9xDR2SD8AgBo4SNCgDnZWc0BMAkyeWoBPapJg+sfM5+YbAN4SQByGhKV1j4U+s5DZga7i1Qh7NXUL2RY/Gcp2qN7EXfyASALluIXpz5BfllvfwprGjhmcM6F7tp6GNTTveGIuW5BJnxsyVMXUiqAvBnIjShSiciMKFKJ2I2oWonIjKhahdCJK5EHk2M8Z+WGLgTytvLzRvr+10iTfvC6sbaQalbbrjnV0gU/JlVd+xc7wEn3fMAVZpKqTh2l4X+Fc2Xmcv6iYBummobhoAZ6FwFgAvQuFFALwMhZcB8CoUXgXA61B47Q9nWSAcZwHwPBQesD8ZDoXjAHjo5sfzDu1Us1/c9ew/SLj1TsM0Wo12GOGKWwhBv9/I7Qs3i/oLnytZ81698u0IbR0cVHy/FXD3QtOh6QxP0PX11WB89iNgWKxWXToCE8K3apyczLQ2vt7V955l0WbMBwTvYD60aFMuuT6e4ACF6IemXbx+8o/0ILndeDhwvTVgJ6Y74/ZbClcEOCO84ozKGGuE/a3RYeTdg2wRrgJ80Vq+dYAxWmGQLMAZrTHyAGu0xsAB3miNQQLM0RqDBrijNQbzdkfYx2WQeW/clx0L2PlTkQsYsOJyeg0m/Td0aOB0PermddodeYY+Om1/jU0H76CzVLqHYmdJSRnl04jXUU2qKDj2g9cxJpD4fB6axaC9vjzNoyyg33xTHAX3m28a54w9ldMouKdyFmVePZXHOWNP5WWUp/dUXkXBPZXXUbbbD86yKLjftLA8qhrxhOMouOe0kKiCwVM5jYJ7KmdRdZSn8iIK7qm8jCp1PJVXUXBP5XVUBeinvMii4H7KizygAiRRFWCBA0LguBAkqsgkDy0yh8kqGoiUqsGKtumg3uwHJUHrfbEZUW0WcTU0fmh6nfqd7rk0U3Bj9dheSrpbYsyZ1zM8QhDoMP+NkKBXCHORzwpc07pmVU7qOqPn819wAt1k"
    game.surfaces[1].create_entities_from_blueprint_string{
      string=bp, position={0, 0}
    }
    local lrs = game.surfaces[1].find_entity("rocket-silo", {0, 0})
    lrs.set_recipe("pktff-rocket-part-gravity-10")
  ]]
}
local many_kinds = {
  checkerboard = true,
  -- otherwise it complains????????
  planet = "nauvis",
  init = [[
    game.surfaces[1].create_global_electric_network()
    game.forces.player.enable_all_recipes()
    game.simulation.camera_alt_info = true
    -- game.simulation.camera_zoom = 1.8
    local bp = "0eNrFmuuOozgQhd+F3zDCN8B5lVUroomTtpbbchl1tpV3X5P0JukOlXJZLc38GTWQz8fmhFMp/BG91rPpB9tO0eYjslXXjtHmr49otIe2rJdjbdmYaBNVb6axVVknfV26i09xZNudeY827BSvXN7b3txdxE8vcWTayU7WXAY4/3HctnPzagZHif//pG33tnWnEjfiOEVx1Hej+1jXLvRlPM1+qTg6RpskS3+p8xiXT2xHM022PYzLlYNput9mO7tz9WQGs9vayTTu1L6sRxNHl8MXLZ8jD131t5mS/WxqN2zVzcui8DSOmm63nC+npDblWdN17i+nZfrfJsOvk6m7cueOPJuE0m4KOzuY6nK+iKPp2C8f7uapn5elfhhAPK7WecEfx8nz6zg5vFifsLfjbugOpl04ZqjcoOXBnO+NWzp3pJzmwf0t0pU1WVsHGX+xw1N1mVO3glDeMy0YYaZl03StLZGJJkL5TTTDJnonDphofkVMQ9mOfTdMyaupn38BPmd6754VdBGEznzQmnCH1frEWUpgSIDBCDcAYnACA5qLCFpq5bPUTAaxpRdbEe6BAOaeERgcYOQoQ6OMAmUUKEMTvAAweEpgAGvKcV9zVAfua4EywnwtfLzHw3zNvdg3X3+rX5664lJWOLI95/D0NsyjKxbOlUGyH7omuUvKy2Xbf+aydkO7y9tuaFwttCYn85dzd2NxObc4o6jJCWoygpqvdRRFESGpCv1N0Z0VGF+D377Te5fjiW1HM0yrxVlRwGy5Vo6lQRZmPhYWLIjttyaCE+ApFS78A0EW6w8eIf0f5iBD+YcKyMArvBRl5P6BADIK/4c5yND+oQIxJB5uCmXg4SZRBh5uqMck6tPb0w9koD4tUJ9K1Kca9Ye88+nc9Ktf4zsC+mSTqGc16jeJelbjfkM9q1G/KdSzGvWbQj2rUb8p1LMa9ZtCPavRZ5pCPatRzyrMszxFPasylIE+W1WOMlCfqgJloD5V2rdfwVPUbBnhl7EE2goZIwQoxOCEAIUYghB+EEMSQhhiKEKAQoyMEKAQIycEKMQoCAEKMTQhQKHWVUoIUIjBCAEKMTghQCGG8A7QzCdAc0kIUEiTIgQoxMgIAQoxckKAQoyCEKAQQxMCFGAUKSFAIQYjBCjE4IQAhRiCEKAQQxICFGIoQoBCjCwkQCHYzbCmdt/SwVaJac1wOLpf/+6n/76sVsHZJzZ33+/Xeb83w3a0/y4vCNLrv7XhipBuk3zs0K61V7p3u3MahkuLpXs/krtPhQ7pPgXJc7dtWeuysjuaRp2G9KSea2x5J5MHoURdLKQz9ahrtVGieUBn6pG9Fj86qHHrq1uGdI984YRXEhJoW+uMULhCjJxQQEOMglD8QgxNKFyh1xppSqhcQQgjlK4ghNK4ASFh7gZxQW8iJPQ+LKU4OIUghLdqkkEQSucRVEIxMahEE7wDKWGU5iOkxOOVMX53GMXFoJIwF4OawlwMqiO4WBQQhOBioSEIwcWwEoKLYSUEF4NKOMHFoBJOcDGshOBiWEmQi2FNQS6G1amAHVMC30d0rcN/ZL8U41nAdicPmV/r8R/SmvtrVQStrkovG0QlU74iC3+R+Z9eUB1k+RzaipSGbKkU8ke3VFZd75Zi+Qk3mdueSpYGbKpkd2/CPbZViuz0sJHyxY3hFLsjt12vcfTbaT4jVMa11Nr9J7TIxOn0H0VGqgw="
    game.surfaces[1].create_entities_from_blueprint_string{
      string=bp, position={5, 0}
    }
  ]]
}
return {
  intro = intro,
  many_kinds = many_kinds
}
