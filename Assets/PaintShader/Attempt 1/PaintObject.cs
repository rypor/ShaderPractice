using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaintObject : MonoBehaviour
{
    const int TEXTURE_SIZE = 1024;

    public RenderTexture _paintMask;
    Renderer _rend;
    int mainTextureID = Shader.PropertyToID("_MainTex");

    public RenderTexture PaintMask { get => _paintMask; set => _paintMask = value; }
    public Renderer Rend { get => _rend; set => _rend = value; }

    // Start is called before the first frame update
    void Start()
    {
        PaintMask = new RenderTexture(TEXTURE_SIZE, TEXTURE_SIZE, 0);
        PaintMask.filterMode = FilterMode.Bilinear;
        PaintMask.Create();

        _rend = GetComponent<Renderer>();
        _rend.material.mainTexture = _paintMask;

        PaintManager01.instance.Init(this);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
