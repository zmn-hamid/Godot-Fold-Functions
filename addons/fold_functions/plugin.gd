@tool
extends EditorPlugin

var script_editor: ScriptEditor
var command_palette: EditorCommandPalette

func _enter_tree():
    # get script editor - used in `fold`
    var editor_interface: EditorInterface = get_editor_interface()
    if is_instance_valid(editor_interface):
        script_editor = editor_interface.get_script_editor()
    # get command palette
    command_palette = editor_interface.get_command_palette()
    
    # add commands
    
    command_palette.add_command(
        "Unfold All",
        "script_text_editor/unfold_all",
        fold.bind(false, -1),
    )
    for i in range(5):
        command_palette.add_command(
            "Fold Level %s" % (i+1),
            "script_text_editor/fold_level_%s" % (i+1),
            fold.bind(true, i+1),
        )

func _exit_tree():
    command_palette.remove_command(
        "unfold_all"
    )
    for i in range(5):
        command_palette.add_command(
            "Fold Level %s" % (i+1),
            "script_text_editor/fold_level_%s" % (i+1),
            fold.bind(true, i+1),
        )
        command_palette.remove_command("fold_level_%s" % (i+1))

func fold(p_fold: bool, level: int) -> void:
    '''level -1 means all - to be used with p_fold=false'''
    # get the code editor
    var code_edit: CodeEdit
    if is_instance_valid(script_editor):
        var current_script_editor_base: ScriptEditorBase = script_editor.get_current_editor()
        if is_instance_valid(current_script_editor_base):
            code_edit = current_script_editor_base.get_base_editor()
    if !is_instance_valid(code_edit):
        push_warning('Can\'t fold outside the code editor')
        return
    
    # unfold all if defined
    if !p_fold and level == -1:
        code_edit.unfold_all_lines()
        return

    # fold all lines with the given indent level
    for line_idx in range(code_edit.get_line_count()):
        var indent: int = code_edit.get_indent_level(line_idx) / code_edit.indent_size
        if code_edit.can_fold_line(line_idx):
            if level - 1 == indent:
                code_edit.fold_line(line_idx)
