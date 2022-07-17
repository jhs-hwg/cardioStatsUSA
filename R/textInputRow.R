

textInputRow<-function (inputId, label, value = "")
{
 div(style="display:inline-block",
     tags$label(label, `for` = inputId),
     tags$input(id = inputId, type = "text", value = value,class="input-small"))
}
