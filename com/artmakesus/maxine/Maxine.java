package com.artmakesus.maxine;

import java.util.*;
import java.io.*;
import java.net.*;
import java.nio.charset.*;

import processing.core.*;
import processing.data.*;

public class Maxine {
	static {
		try {
			System.loadLibrary("Maxine");
		} catch (UnsatisfiedLinkError e) {
			System.err.println("Native library failed to load.\n" + e);
			System.exit(1);
		}
	}

	private PApplet parent;
	private Socket socket;
	private InputStream in;
	private OutputStream out;

	public Maxine(PApplet parent) {
		this.parent = parent;
		parent.registerMethod("dispose", this);

		try {
			socket = new Socket("localhost", 4444);
			in = socket.getInputStream();
			out = socket.getOutputStream();
		} catch (UnknownHostException e) {
		} catch (IOException e) {
		}
	}

	public List<Item> items() {
		ArrayList<Item> items = new ArrayList<Item>();

		// Send command
		JSONObject object = new JSONObject();
		object.setString("type", "items");
		byte[] outData = object.toString().getBytes(Charset.forName("UTF-8"));
		try {
			out.write(outData);
			out.flush();
		} catch (IOException e) {
			return items;
		}

		// Receive data
		try {
			byte []inData = new byte[4096];
			int nread = in.read(inData);
			byte[] buf = Arrays.copyOfRange(inData, 0, nread);
			JSONArray array = JSONArray.parse(new String(buf));

			// Parse data
			for (int i = 0; i < array.size(); i++) {
				int id = array.getInt(i, -1);
				if (id >= 0) {
					items.add(new Item(this, id));
				}
			}
		} catch (IOException e) {
			return items;
		}

		return items;
	}

	public void dispose() {
		try {
			if (socket != null) {
				socket.close();
				socket = null;
			}
		} catch (IOException e) {
		}
	}

	public class Item {
		private Maxine parent;
		private int id;

		public Item(Maxine parent, int id) {
			this.parent = parent;
			this.id = id;
		}

		public void createTexture(int width, int height) {
			// Send command
			JSONObject object = new JSONObject();
			object.setString("type", "createSharedTexture");
			object.setInt("id", id);
			object.setInt("width", width);
			object.setInt("height", height);
			byte[] outData = object.toString().getBytes(Charset.forName("UTF-8"));
			try {
				out.write(outData);
				out.flush();
			} catch (IOException e) {
			}
		}

		public void destroyTexture() {
			// Send command
			JSONObject object = new JSONObject();
			object.setString("type", "destroySharedTexture");
			object.setInt("id", id);
			byte[] outData = object.toString().getBytes(Charset.forName("UTF-8"));
			try {
				out.write(outData);
				out.flush();
			} catch (IOException e) {
			}
		}

		public void invalidateTexture() {
			// Send command
			JSONObject object = new JSONObject();
			object.setString("type", "invalidateSharedTexture");
			object.setInt("id", id);
			byte[] outData = object.toString().getBytes(Charset.forName("UTF-8"));
			try {
				out.write(outData);
				out.flush();
			} catch (IOException e) {
			}
		}

		public void setTexture(PImage image) {
			image.loadPixels();
			parent.setTexturePixels(this.id, image.pixels);
			image.updatePixels();
		}

		public Maxine getParent() {
			return parent;
		}

		public int getID() {
			return id;
		}
	}

	public native void setTexturePixels(int id, int[] pixels);
}

