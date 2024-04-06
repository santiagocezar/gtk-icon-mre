use gtk::{glib,gio};
use gtk::prelude::*;
use glib::clone;

fn on_activate(application: &gtk::Application) {
    let window = gtk::ApplicationWindow::new(application);


    let icon_theme = gtk::IconTheme::for_display(&WidgetExt::display(&window));

    icon_theme.add_resource_path("/io/github/santiagocezar/maniatic-launcher/icons/");
    icon_theme.add_resource_path("/io/github/santiagocezar/maniatic-launcher/icons/scalable/actions/");

    for search_path in icon_theme.resource_path() {
        println!("Search {}", search_path);
    }

    println!("Icon theme has one-symbolic? {:?}", icon_theme.has_icon("one-symbolic"));

    let img = gtk::Image::from_icon_name("one-symbolic");

    window.set_child(Some(&img));
    window.present();
}

fn main() {
    gio::resources_register_include!("compiled.gresource")
        .expect("Failed to register resources.");

    let app = gtk::Application::builder()
        .application_id("io.github.santiagocezar.maniatic-launcher")
        .build();

    app.connect_activate(on_activate);

    app.run();
}
