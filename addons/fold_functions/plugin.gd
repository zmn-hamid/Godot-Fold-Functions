@tool
extends EditorPlugin

var editor_interface: EditorInterface
var script_editor: ScriptEditor

var command_palette: EditorCommandPalette

func _enter_tree():
    editor_interface = get_editor_interface()
    script_editor = editor_interface.get_script_editor()
    
    command_palette = get_editor_interface().get_command_palette()
    
    # add commands
    
    command_palette.add_command(
        "Unfold All",
        "script_text_editor/unfold_all",
        unfold_all,
    )
    command_palette.add_command(
        "Fold Level 1",
        "script_text_editor/fold_level_1",
        fold_level_1,
    )
    command_palette.add_command(
        "Fold Level 2",
        "script_text_editor/fold_level_2",
        fold_level_2,
    )
    command_palette.add_command(
        "Fold Level 3",
        "script_text_editor/fold_level_3",
        fold_level_3,
    )
    command_palette.add_command(
        "Fold Level 4",
        "script_text_editor/fold_level_4",
        fold_level_4,
    )
    command_palette.add_command(
        "Fold Level 5",
        "script_text_editor/fold_level_5",
        fold_level_5,
    )

func _exit_tree():
    command_palette.remove_command(
        "unfold_all"
    )
    command_palette.remove_command(
        "fold_level_1"
    )
    command_palette.remove_command(
        "fold_level_2"
    )
    command_palette.remove_command(
        "fold_level_3"
    )
    command_palette.remove_command(
        "fold_level_4"
    )
    command_palette.remove_command(
        "fold_level_5"
    )

func _fold(p_fold: bool, level: int):
    '''level -1 means all - to be used with p_fold=false'''
    # get the code editor
    var code_editor: CodeEdit
    var script_editor_base = script_editor.get_current_editor()
    if is_instance_valid(script_editor_base):
        code_editor = script_editor_base.get_base_editor()
    if not code_editor:
        return
    
    # unfold all if defined
    if !p_fold and level == -1:
        code_editor.unfold_all_lines()
        return

    # fold all lines with the given indent level
    for line in range(code_editor.get_line_count()):
        var indent: int = code_editor.get_indent_level(line) / code_editor.indent_size
        
        if code_editor.can_fold_line(line):
            if level - 1 == indent:
                code_editor.fold_line(line)

func unfold_all():
    _fold(false, -1)

func fold_level_1():
    _fold(true, 1)

func fold_level_2():
    _fold(true, 2)

func fold_level_3():
    _fold(true, 3)
    
func fold_level_4():
    _fold(true, 4)
    
func fold_level_5():
    _fold(true, 5)
