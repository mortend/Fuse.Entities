using Uno;
using Uno.Graphics;

namespace Fuse.Drawing.Batching
{
	public class BatchIndexBuffer
	{
		IndexType dataType;
		public IndexType DataType
		{
			get { return dataType; }
			set
			{
				if (buf != null) throw new Exception("Index type cannot be changed after buffer is written to");
				dataType = value;
			}
		}

		public int StrideInBytes { get { return IndexTypeHelpers.GetStrideInBytes(DataType); } }

		int maxIndices;

		BufferUsage usage;

		public BatchIndexBuffer(IndexType type, int maxIndices, bool staticBatch)
		{
			dataType = type;
			this.maxIndices = maxIndices;
			this.usage = staticBatch ? BufferUsage.Immutable : BufferUsage.Dynamic;
		}

		public BatchIndexBuffer(IndexType type, byte[] data)
		{
			this.DataType = type;
			this.usage = BufferUsage.Immutable;
			this.buf = new byte[data.Length];
			for (int i =0; i<buf.Length; i++)
				this.buf[i] = data[i];
		}

		[Obsolete]
		public BatchIndexBuffer(IndexType type, Buffer data)
		{
			this.DataType = type;
			this.usage = BufferUsage.Immutable;
			this.buf = new byte[data.SizeInBytes];
			for (int i =0; i<buf.Length; i++)
				this.buf[i] = data[i];
		}

		byte[] buf;
		public byte[] Bytes
		{
			get
			{
				if (buf == null) buf = new byte[maxIndices * StrideInBytes];
				return buf;
			}
		}

		[Obsolete("Use Bytes instead")]
		public Buffer Buffer
		{
			get { return new Buffer(Bytes); }
		}

		int _position;
		public int Position
		{
			get { return _position; }
			set { _position = value; }
		}

		public void Write(byte value)
		{
			Bytes.Set(_position, value);
			_position += 1;
		}

		public void Write(ushort value)
		{
			Bytes.Set(_position, value);
			_position += 2;
		}

		IndexBuffer ibo;
		public IndexBuffer IndexBuffer
		{
			get
			{
				if (buf == null)
					return null;
				Flush();
				return ibo;
			}
		}

		bool isDirty = true;
		public void Flush()
		{
			if (buf != null && isDirty)
			{
				if (ibo == null)
					ibo = new IndexBuffer(buf.Length, usage);
				else
					ibo.Update(buf);

				isDirty = false;
			}
		}

		public void Invalidate()
		{
			isDirty = true;
		}
	}
}
