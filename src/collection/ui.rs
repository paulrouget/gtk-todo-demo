use adw::prelude::*;
use adw::subclass::prelude::*;
use glib::subclass::InitializingObject;
use glib::{Object, ParamSpec, ParamSpecString, Value};
use gtk::{glib, CompositeTemplate, Image, Label};
use once_cell::sync::Lazy;

use crate::collection::CollectionObject;

glib::wrapper! {
  pub struct CollectionRow(ObjectSubclass<CollectionRowImp>)
    @extends gtk::Box, gtk::Widget,
    @implements gtk::Accessible, gtk::Buildable, gtk::ConstraintTarget, gtk::Orientable;
}

impl CollectionRow {
  pub fn new(collection_object: &CollectionObject) -> Self {
    let obj = Object::builder().build();

    collection_object
      .bind_property("title", &obj, "title")
      .flags(glib::BindingFlags::SYNC_CREATE)
      .build();

    collection_object
      .bind_property("count", &obj, "count")
      .flags(glib::BindingFlags::SYNC_CREATE)
      .build();

    obj
  }
}

#[derive(CompositeTemplate, Default)]
#[template(resource = "/com/paulrouget/todo/collection.ui")]
pub struct CollectionRowImp {
  #[template_child]
  pub image: TemplateChild<Image>,
  #[template_child]
  pub title: TemplateChild<Label>,
  #[template_child]
  pub count: TemplateChild<Label>,
}

// The central trait for subclassing a GObject
#[glib::object_subclass]
impl ObjectSubclass for CollectionRowImp {
  type ParentType = gtk::ListBoxRow;
  type Type = super::CollectionRow;

  const NAME: &'static str = "CollectionRow";

  fn class_init(klass: &mut Self::Class) {
    klass.bind_template();
  }

  fn instance_init(obj: &InitializingObject<Self>) {
    obj.init_template();
  }
}

impl ObjectImpl for CollectionRowImp {
  fn properties() -> &'static [ParamSpec] {
    static PROPERTIES: Lazy<Vec<ParamSpec>> = Lazy::new(|| vec![ParamSpecString::builder("title").build(), ParamSpecString::builder("count").build()]);
    PROPERTIES.as_ref()
  }

  fn set_property(&self, _id: usize, value: &Value, pspec: &ParamSpec) {
    match pspec.name() {
      "title" => {
        self.title.set_label(value.get().expect("not a string"));
      },
      "count" => {
        self.count.set_label(value.get().expect("not a string"));
      },
      _ => unimplemented!(),
    }
  }

  fn constructed(&self) {
    self.parent_constructed();
  }
}

impl WidgetImpl for CollectionRowImp {}

impl ListBoxRowImpl for CollectionRowImp {}
