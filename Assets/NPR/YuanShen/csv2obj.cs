﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.IO;

public class csv2obj : MonoBehaviour
{
    // Start is called before the first frame update

    void Start()
    {
        Parse(@"E:\米哈游\Mesh Data\Character 1\body1.csv");
        Parse(@"E:\米哈游\Mesh Data\Character 1\body2.csv");
        Parse(@"E:\米哈游\Mesh Data\Character 1\face1.csv");
        Parse(@"E:\米哈游\Mesh Data\Character 1\face2.csv");
        Parse(@"E:\米哈游\Mesh Data\Character 1\eyebow.csv");
        Parse(@"E:\米哈游\Mesh Data\Character 1\hair.csv");
    }

    // Update is called once per frame
    void Update()
    {

    }

    class MeshData
    {
        public List<int> VTX;
        public List<int> IDX;
        public List<Vector3> Position;
        public List<Vector3> Normal;
        public List<Color> VertexColor;
        public List<Vector2> Texcoord0;
        public List<Vector2> Texcoord1;
        public MeshData()
        {
            this.VTX = new List<int>();
            this.IDX = new List<int>();
            this.Position = new List<Vector3>();
            this.Normal = new List<Vector3>();
            this.VertexColor = new List<Color>();
            this.Texcoord0 = new List<Vector2>();
            this.Texcoord1 = new List<Vector2>();
        }
    }

    public Material material;

    void Parse(string path)
    {
       
        string[] lines = File.ReadAllLines(path);

        //print(lines[0].Length);

        MeshData meshData = new MeshData();

        for (int i = 1; i < lines.Length; i++)
        {
            var line = lines[i];
            string[] words = line.Split(',');

            int index = 0;
            meshData.VTX.Add(int.Parse(words[index++]));
            meshData.IDX.Add(int.Parse(words[index++]));
            meshData.Position.Add(new Vector3(float.Parse(words[index++]), float.Parse(words[index++]), float.Parse(words[index++])));
            meshData.Normal.Add(new Vector3(float.Parse(words[index++]), float.Parse(words[index++]), float.Parse(words[index++])));
            meshData.VertexColor.Add(new Color(float.Parse(words[index++]), float.Parse(words[index++]), float.Parse(words[index++]), float.Parse(words[index++])));
            meshData.Texcoord0.Add(new Vector2(float.Parse(words[index++]), float.Parse(words[index++])));
            meshData.Texcoord1.Add(new Vector2(float.Parse(words[index++]), float.Parse(words[index++])));
        }

        var go = new GameObject(path);
        go.transform.position = Vector3.zero;
        go.transform.SetParent(transform);
        MeshFilter mf = go.AddComponent<MeshFilter>();
        MeshRenderer mr = go.AddComponent<MeshRenderer>();
        Mesh mesh = new Mesh();
        mesh.vertices = meshData.Position.ToArray();
        mesh.colors = meshData.VertexColor.ToArray();
        mesh.normals = meshData.Normal.ToArray();
        mesh.uv = meshData.Texcoord0.ToArray();
        mesh.uv2 = meshData.Texcoord1.ToArray();
        mesh.triangles = meshData.VTX.ToArray();
        mf.mesh = mesh;
        mr.material = material;
    }
}
