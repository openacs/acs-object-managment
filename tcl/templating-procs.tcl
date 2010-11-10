ad_library {

    Supporting code for automagically massaging values back and forth between forms
    and the database.

    acs-templating has the necessary code but no standard set of naming conventions.

    For instance, to transform a value from a form date to a sql date, you call
    "get_property sql_date".

    In this library, if a transformation is necessary from (for instance) the list
    form to to_date(), it can be found by calling template::util::date::to_sql.

    The code should move to acs-templating eventually.  This is something I've
    wanted to do since kludging around the lack when writing ad_form many moons ago.

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date August 28, 2009
    @cvs-id $Id$

}

namespace eval template {}
namespace eval template::util {}
namespace eval template::util::timestamp {}
namespace eval template::widget {}
namespace eval template::data {}
namespace eval template::data::validate {}
namespace eval template::data::transform {}
namespace eval template::data::to_sql {}
namespace eval template::data::from_sql {}

# handle date transformations using a standardized naming convention.

ad_proc template::data::to_sql::date { value } {
} {
    return [template::util::date::get_property sql_date $value]
}

ad_proc template::data::from_sql::date { value } {
} {
    return [template::util::date::acquire ansi $value]
}

# The abstract type system includes a timestamp type, so we need to implement one
# in the template "data type" system (even though in reality it should really just
# be a widget working on the abstract type "date", or "timestamp" should replace "date")

ad_proc -public template::data::validate::timestamp {
  value_ref
  message_ref
} {
  Validate that a submitted date conforms to the template system's notion
  of what a date should be.

  @param value_ref Reference variable to the submitted value
  @param message_ref Reference variable for returning an error message

  @return True (1) if valid, false (0) if not
} {

  upvar 2 $message_ref message $value_ref value

  return [template::util::date::validate $value message]
}

ad_proc template::data::to_sql::timestamp { value } {
} {
    return [template::data::to_sql::date $value]
}

ad_proc template::data::from_sql::timestamp { value } {
} {
    return [template::data::from_sql::date $value]
}

ad_proc -public template::data::transform::timestamp { element_ref } {
    Collect a timestamp object from the form
} {
    upvar $element_ref element
    return [template::data::transform::date element]
}

ad_proc -public template::util::timestamp::set_property { what date value } {

    get a property in a list created by a timestamp  widget.  It's the same
    as the date one.

    This is needed by the form builder to support explicit from_sql element modifiers.

} {
    return [template::util::date::set_property $what $date $value]
}

ad_proc -public template::util::timestamp::get_property { what date } {

    Replace a property in a list created by a timestamp  widget.  It's the same
    as the date one.

    This is needed by the form builder to support explicit to_sql element modifiers.
} {
    return [template::util::date::get_property $what $date]
}

ad_proc -public template::widget::timestamp { element_reference tag_attributes } {
    Render a timestamp widget.  Default is the localized version.
} {

    upvar $element_reference element

    if { ! [info exists element(format)] } { 
        set element(format) "[_ acs-lang.localization-formbuilder_date_format] [_ acs-lang.localization-formbuilder_time_format]"
    }
    return [template::widget::date element $tag_attributes]
}

# handle richtext transformations using a standardized naming convention.

namespace eval template::util::richtext {}

ad_proc template::data::to_sql::richtext { value } {
    return "[list [template::util::richtext::get_property content $value] \
                  [template::util::richtext::get_property format $value]]"
}

ad_proc template::data::from_sql::richtext { value } {
    set value
}

ad_proc -public template::data::validate::number {
  value_ref
  message_ref
} {
  Validate number - any float - should be any rational number?

  @param value_ref Reference variable to the submitted value
  @param message_ref Reference variable for returning an error message

  @return True (1) if valid, false (0) if not
} {

  upvar 2 $message_ref message $value_ref value

  # Not allowing for scientific notation. Would the databases swallow it?
  set result [regexp {^([+-]?)(?=\d|\.\d)\d*(\.\d*)?$} $value]

  if { ! $result } {
    set message "Invalid number \"$value\""
  }
   
  return $result 
}

ad_proc -public template::data::validate::enumeration {
  value_ref
  message_ref
} {
  Validate enumeration as a unique csv alphanum list.

  @param value_ref Reference variable to the submitted value
  @param message_ref Reference variable for returning an error message

  @return True (1) if valid, false (0) if not
} {

  upvar 2 $message_ref message $value_ref value

  # alphanumeric csv
  set result [regexp {^([A-z0-9]+,?)+$} $value]
  
  if { ! $result } {
    set message "Invalid enumeration \"$value\""
    return $result
  }
  
  # unique list
  set list [split $value ,]
  set result [expr [llength $list] == [llength [lsort -unique $list]]]
  
  if { ! $result } {
    set message "Invalid enumeration. \"$value\" does not contain unique values."
  }  
  
  return $result 
}

ad_proc -public template::data::validate::time_of_day {
  value_ref
  message_ref
} {
  Validate time of day.

  @param value_ref Reference variable to the submitted value
  @param message_ref Reference variable for returning an error message

  @return True (1) if valid, false (0) if not
} {

  upvar 2 $message_ref message $value_ref value

  return [template::util::date::validate $value message]
}
