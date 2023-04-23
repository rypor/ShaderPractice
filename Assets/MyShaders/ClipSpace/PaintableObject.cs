using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PaintableObject : MonoBehaviour
{
    public const int TEXTURE_SIZE = 1024;
    public RenderTexture paintMaskRenderTexture;
    private Renderer rend;

    int maskTextureID = Shader.PropertyToID("_MaskTexture");

    public RenderTexture getMask() => paintMaskRenderTexture;
    public Renderer getRenderer() => rend;

    private void Start()
    {
        paintMaskRenderTexture = new RenderTexture(TEXTURE_SIZE, TEXTURE_SIZE, 0);
        paintMaskRenderTexture.filterMode = FilterMode.Bilinear;

        rend = GetComponent<Renderer>();
        rend.material.SetTexture(maskTextureID, paintMaskRenderTexture);

        PaintManager.instance.InitTextures(this);
    }
}
