package snow.api.buffers;

#if js

    @:forward
    abstract Uint32Array(js.html.Uint32Array)
        from js.html.Uint32Array
        to js.html.Uint32Array {

        public inline static var BYTES_PER_ELEMENT : Int = 4;

        @:generic
        public inline function new<T>(
            ?elements:Int,
            ?array:Array<T>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {
            if(elements != null) {
                this = new js.html.Uint32Array( elements );
            } else if(array != null) {
                this = new js.html.Uint32Array( untyped array );
            } else if(view != null) {
                this = new js.html.Uint32Array( untyped view );
            } else if(buffer != null) {
                if(len == null) {
                    this = new js.html.Uint32Array( buffer, byteoffset );
                } else {
                    this = new js.html.Uint32Array( buffer, byteoffset, len );
                }
            } else {
                this = null;
            }
        }

        @:arrayAccess @:extern inline function __set(idx:Int, val:UInt) : Void this[idx] = val;
        @:arrayAccess @:extern inline function __get(idx:Int) : UInt return this[idx];


            //non spec haxe conversions
        inline public static function fromBytes( bytes:haxe.io.Bytes, ?byteOffset:Int=0, ?len:Int ) : Uint32Array {
            if(byteOffset == null) return new js.html.Uint32Array(cast bytes.getData());
            if(len == null) return new js.html.Uint32Array(cast bytes.getData(), byteOffset);
            return new js.html.Uint32Array(cast bytes.getData(), byteOffset, len);
        }

        inline public function toBytes() : haxe.io.Bytes {
            #if (haxe_ver < 3.2)
                return @:privateAccess new haxe.io.Bytes( this.byteLength, cast new js.html.Uint8Array(this.buffer) );
            #else
                return @:privateAccess new haxe.io.Bytes( cast new js.html.Uint8Array(this.buffer) );
            #end
        }

        inline function toString() return 'Uint32Array [byteLength:${this.byteLength}, length:${this.length}]';

    }

#else

    import snow.api.buffers.ArrayBufferView;
    import snow.api.buffers.TypedArrayType;

    @:forward
    abstract Uint32Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

        public inline static var BYTES_PER_ELEMENT : Int = 4;

        public var length (get, never):Int;

        @:generic
        public inline function new<T>(
            ?elements:Int,
            ?array:Array<T>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {

            if(elements != null) {
                this = new ArrayBufferView( elements, Uint32 );
            } else if(array != null) {
                this = new ArrayBufferView(0, Uint32).initArray(array);
            } else if(view != null) {
                this = new ArrayBufferView(0, Uint32).initTypedArray(view);
            } else if(buffer != null) {
                this = new ArrayBufferView(0, Uint32).initBuffer(buffer, byteoffset, len);
            } else {
                throw "Invalid constructor arguments for Uint32Array";
            }
        }

    //Public API

        public inline function subarray( begin:Int, end:Null<Int> = null) : Uint32Array return this.subarray(begin, end);


            //non spec haxe conversions
        inline public static function fromBytes( bytes:haxe.io.Bytes, ?byteOffset:Int=0, ?len:Int ) : Uint32Array {
            return new Uint32Array(bytes, byteOffset, len);
        }

        inline public function toBytes() : haxe.io.Bytes {
            return this.buffer;
        }

    //Internal

        inline function get_length() return this.length;


        @:noCompletion
        @:arrayAccess @:extern
        public inline function __get(idx:Int) {
            return ArrayBufferIO.getUint32(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT));
        }

        @:noCompletion
        @:arrayAccess @:extern
        public inline function __set(idx:Int, val:UInt) : Void {
            ArrayBufferIO.setUint32(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT), val);
        }

        inline function toString() return 'Uint32Array [byteLength:${this.byteLength}, length:${this.length}]';

    }

#end //!js
