using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Runtime.Implementation.Internal;

namespace Fuse.Content.Models
{
    public sealed class IndexArray
    {
        readonly byte[] _buffer;
        readonly IndexType _type;

        public IndexType Type
        {
            get { return _type; }
        }

        public byte[] Bytes
        {
            get { return _buffer; }
        }

        [Obsolete("Use Bytes instead")]
        public Buffer Buffer
        {
            get { return new Buffer(_buffer); }
        }

        public int Count
        {
            get { return _buffer.Length / IndexTypeHelpers.GetStrideInBytes(_type); }
        }

        public IndexArray(IndexType type, byte[] buffer)
        {
            _buffer = buffer;
            _type = type;
        }

        [Obsolete("Use the byte[] overload instead")]
        public IndexArray(IndexType type, Buffer buffer)
        {
            _buffer = buffer.GetBytes();
            _type = type;
        }

        public IndexArray(byte[] data)
            : this(IndexType.Byte, data)
        {
        }

        public IndexArray(ushort[] data)
            : this(IndexType.UShort, BufferConverters.ToBuffer(data))
        {
        }

        public IndexArray(uint[] data)
            : this(IndexType.UInt, BufferConverters.ToBuffer(data))
        {
        }

        public int GetInt(int index)
        {
            switch (_type)
            {
                case IndexType.Byte:
                    return (int)_buffer.GetByte(index * 1);

                case IndexType.UShort:
                    return (int)_buffer.GetUShort(index * 2);

                case IndexType.UInt:
                    return (int)_buffer.GetUInt(index * 4);

                default:
                    // TODO: Error
                    return 0;
            }
        }

        static byte[] ToBytes(ushort[] data)
        {
            var result = new byte[data.Length * sizeof(ushort)];
            // ...
            return result;
        }
    }
}
