function restrict_value_widget(param) {
    eval('var el = document.widget_register.'+param+'_source;');
    for (i=0;i<el.length;i++)
    {
        if (el[i].checked)
        {
            source = el[i].value;
        }
    } 
    if (source == 'eval') {
        document.getElementById(param+'_eval').disabled = false;
        document.getElementById(param+'_literal').value = ""
        document.getElementById(param+'_literal').disabled = true;
    }
    if (source == 'literal') {
        document.getElementById(param+'_literal').disabled = false;
        document.getElementById(param+'_eval').selectedIndex = 0;
        document.getElementById(param+'_eval').disabled = true;
    }
}