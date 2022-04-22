using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using UnityEngine;
using Votanic.vXR.vGear;

public class DisableRigidBody : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
    }

    private int _collidingCount;

    private int _prevCollidingCount;

    public void DisableRigidBodyNow()
    {
        GetComponent<Rigidbody>().useGravity = false;
        GetComponent<Rigidbody>().detectCollisions = true;
        GetComponent<Rigidbody>().isKinematic = true;
        Debug.Log("hi");
        foreach (var material in GetComponent<Renderer>().materials)
        {
            material.color = Color.black;
        }
    }

    public void EnableRigidBodyNow()
    {
        GetComponent<Rigidbody>().useGravity = true;
        GetComponent<Rigidbody>().detectCollisions = true;
        GetComponent<Rigidbody>().isKinematic = true;
        Debug.Log("bye");
        foreach (var material in GetComponent<Renderer>().materials)
        {
            material.color = Color.white;
        }
    }

    public void OnVGearCollisionStaying()
    {
        if (_collidingCount <= 50)
        {
            _collidingCount += 5;
        }
    }

    private void FixedUpdate()
    {
        var vGear = GetComponent<vGear_Interactables>();

        if (_collidingCount >= -5)
        {
            _collidingCount -= 1;
        }

        if (_collidingCount > 0 && !vGear.isGrabbed)
        {
            SnapToPosition();
        }

        if (_collidingCount > 0)
        {
            DisableRigidBodyNow();
        }
        else
        {
            EnableRigidBodyNow();
        }

        _prevCollidingCount = _collidingCount;
    }

    private void SnapToPosition()
    {
        GetComponent<Transform>().position = new Vector3(3.705f, 3.609f, 10.367f);

        GetComponent<Transform>().rotation = new Quaternion(0f, 0f, 0f, 0f);
    }
}