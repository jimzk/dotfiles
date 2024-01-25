def main():
    pass


def handle_result(args, result, target_window_id, boss):
    # Disable moving to page if kitty layout is stack, as there is only one visiable window
    if boss.active_tab.current_layout.name == "stack":
        return
    boss.active_tab.neighboring_window(args[1])


handle_result.no_ui = True
