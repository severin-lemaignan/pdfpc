/**
 * Slide View
 *
 * This file is part of pdf-presenter-console.
 *
 * Copyright (C) 2010-2011 Jakob Westhoff <jakob@westhoffswelt.de>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

using GLib;
using Gdk;

namespace org.westhoffswelt.pdfpresenter {

    /**
     * Base class for every slide view
     */
    public class View: Gtk.DrawingArea {
        /**
         * Signal fired every time a slide is about to be left
         */
        public signal void leaving_slide( int from, int to );

        /**
         * Signal fired every time a slide is entered
         */
        public signal void entering_slide( int slide_number );
        
        /**
         * Renderer to be used for rendering the slides
         */
        protected Renderer.Base renderer;

        /**
         * Base constructor taking the renderer to use as an argument
         */
        protected View( Renderer.Base renderer ) {
            this.renderer = renderer;
            this.set_size_request( 
                renderer.get_width(),
                renderer.get_height()
            );
        }

        /**
         * Create a new Pdf view directly from a file
         *
         * This is a convenience constructor which automatically create a full
         * metadata and rendering chain to be used with the pdf view. The given
         * width and height is used in conjunction with a scaler to maintain
         * aspect ration. The scale rectangle is provided in the scale_rect
         * argument.
         */
        public static View from_metadata( Metadata.Pdf metadata, int width, int height, bool allow_black_on_end,
                                          PresentationController presentation_controller,
                                          out Rectangle scale_rect = null ) {
            var scaler = new Scaler( 
                metadata.get_page_width(),
                metadata.get_page_height()
            );
            scale_rect = scaler.scale_to( width, height );
            var renderer = new Renderer.Pdf( 
                metadata,
                scale_rect.width,
                scale_rect.height
            );
            
            //return new View( renderer, allow_black_on_end, presentation_controller );
            return new View( renderer );
        }
    
        
        /**
         * Return the used renderer object
         */
        public Renderer.Base get_renderer() {
            return this.renderer;
        }

        /**
         * Goto a specific slide number
         *
         * If the slide number does not exist a RenderError.SLIDE_DOES_NOT_EXIST is thrown
         */
        public void display( int slide_number, bool force_redraw=false )
            throws Renderer.RenderError {
        }

        /**
         * Make the screen black. Useful for presentations together with a whiteboard
         */
        public void fade_to_black() {}

        /**
         * Redraw the current slide. Useful for example when exiting from fade_to_black
         */
        public void redraw() throws Renderer.RenderError {}

        /**
         * Return the currently shown slide number
         */
        public int get_current_slide_number() { return 1; }
    }
}
